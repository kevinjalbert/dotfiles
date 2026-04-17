/**
 * StatusLine - A status line extension with rounded box design
 *
 * Features:
 * - Rounded box design — Status renders directly in the editor's top border
 * - Git integration — Async status fetching with 1s cache TTL
 * - Automatically invalidates on file writes/edits
 * - Shows branch, staged (+), unstaged (*), and untracked (?) counts
 * - Context/usage display with progress bar
 * - Event-driven updates (no periodic polling)
 */

import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { visibleWidth } from "@mariozechner/pi-tui";
import { homedir } from "node:os";

const CACHE_TTL_MS = 1000;

interface GitCache {
  branch: string | null;
  staged: number;
  unstaged: number;
  untracked: number;
  timestamp: number;
}

interface StatusState {
  cwd: string;
  tokens?: number;
  contextWindow?: number;
  modelId?: string;
}

export default function (pi: ExtensionAPI) {
  let tuiRef: any = null;

  // Git state — session-scoped (reset on session_start)
  let gitCache: GitCache | null = null;
  let gitPending: Promise<void> | null = null;
  let gitGeneration = 0;

  const state: StatusState = { cwd: "" };

  // ═══════════════════════════════════════════════════════════════════════════
  // Git Helpers
  // ═══════════════════════════════════════════════════════════════════════════

  function runGit(args: string[], timeoutMs = 200): Promise<string | null> {
    return new Promise((resolve) => {
      const proc = spawn("git", args, { stdio: ["ignore", "pipe", "pipe"] });
      let stdout = "";
      let resolved = false;

      const finish = (result: string | null) => {
        if (resolved) return;
        resolved = true;
        clearTimeout(timeoutId);
        resolve(result);
      };

      proc.stdout.on("data", (data) => { stdout += data.toString(); });
      proc.on("close", (code) => { finish(code === 0 ? stdout.trim() : null); });
      proc.on("error", () => { finish(null); });

      const timeoutId = setTimeout(() => { proc.kill(); finish(null); }, timeoutMs);
    });
  }

  async function fetchBranch(): Promise<string | null> {
    const branch = await runGit(["branch", "--show-current"]);
    if (branch === null) return null;
    if (branch) return branch;
    const sha = await runGit(["rev-parse", "--short", "HEAD"]);
    return sha ? `${sha} (detached)` : "detached";
  }

  async function fetchChanges(): Promise<{ staged: number; unstaged: number; untracked: number } | null> {
    const output = await runGit(["status", "--porcelain"], 500);
    if (output === null) return null;

    let staged = 0, unstaged = 0, untracked = 0;
    for (const line of output.split("\n")) {
      if (!line) continue;
      const x = line[0], y = line[1];
      if (x === "?" && y === "?") { untracked++; continue; }
      if (x && x !== " " && x !== "?") staged++;
      if (y && y !== " ") unstaged++;
    }
    return { staged, unstaged, untracked };
  }

  // Returns cached git status synchronously; triggers a background refresh when stale.
  function getGitStatus(): GitCache {
    const now = Date.now();
    if (gitCache && now - gitCache.timestamp < CACHE_TTL_MS) return gitCache;

    if (!gitPending) {
      const gen = gitGeneration;
      gitPending = Promise.all([fetchBranch(), fetchChanges()]).then(([branch, changes]) => {
        gitPending = null;
        if (gen !== gitGeneration) return; // Invalidated during fetch — discard result
        gitCache = {
          branch,
          staged: changes?.staged ?? 0,
          unstaged: changes?.unstaged ?? 0,
          untracked: changes?.untracked ?? 0,
          timestamp: Date.now(),
        };
        requestRender();
      });
    }

    return gitCache ?? { branch: null, staged: 0, unstaged: 0, untracked: 0, timestamp: now };
  }

  function invalidateGitStatus(): void {
    gitCache = null;
    gitPending = null; // Any in-progress fetch is abandoned via the generation check
    gitGeneration++;
  }

  function mightChangeGitState(cmd: string): boolean {
    return [
      /\bgit\s+(checkout|switch|branch\s+-[dDmM]|merge|rebase|pull|reset|worktree)/,
      /\bgit\s+stash\s+(pop|apply)/,
    ].some((p) => p.test(cmd));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Render Helpers
  // ═══════════════════════════════════════════════════════════════════════════

  function requestRender(): void {
    try { tuiRef?.requestRender(); } catch { /* ignore */ }
  }

  function formatK(n?: number): string {
    if (n === undefined) return "?";
    if (n < 1000) return String(n);
    if (n < 10000) return (Math.round((n / 100) || 0) / 10).toFixed(1).replace(/\.0$/, "") + "K";
    return Math.round(n / 1000) + "K";
  }

  function shortenHome(p: string): string {
    const home = homedir();
    if (p === home) return "~";
    if (p.startsWith(home + "/") || p.startsWith(home + "\\")) return "~" + p.slice(home.length);
    return p;
  }

  function renderGitSegment(): string {
    const git = getGitStatus();
    if (!git.branch && git.staged === 0 && git.unstaged === 0 && git.untracked === 0) return "";
    const dirtyParts: string[] = [];
    if (git.unstaged  > 0) dirtyParts.push(`\uF040${git.unstaged}`);  //  pencil  = modified
    if (git.staged    > 0) dirtyParts.push(`\uF067${git.staged}`);   //  plus    = staged
    if (git.untracked > 0) dirtyParts.push(`\uF128${git.untracked}`); //  ?       = untracked
    const dirty = dirtyParts.length > 0 ? ` (${dirtyParts.join(" ")})` : "";
    return git.branch ? `\uE0A0 ${git.branch}${dirty}` : dirty.trim(); //  = branch
  }

  function renderContextSegment(): string {
    if (typeof state.tokens !== "number") return "";
    const { tokens, contextWindow: limit = 0 } = state;
    if (limit > 0) {
      const pct = Math.min(100, Math.round((tokens / limit) * 100));
      const filled = Math.round((pct / 100) * 10);
      const bar = `[${"█".repeat(filled)}${"·".repeat(10 - filled)}]`;
      return `${bar} ${formatK(tokens)}/${formatK(limit)} (${pct}%)`;
    }
    return `${formatK(tokens)} tokens`;
  }

  function getStatusContent(): { left: string; right: string } {
    const left  = [shortenHome(state.cwd || "?"), renderGitSegment()].filter(Boolean).join(" ");
    const right = [state.modelId ?? "", renderContextSegment()].filter(Boolean).join(" ");
    return { left, right };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Editor Component (Rounded Box Design)
  // ═══════════════════════════════════════════════════════════════════════════

  function buildTopBorder(width: number, left: string, right: string, theme: any, bc: (s: string) => string): string {
    const fullWidth = width - 2; // Exclude the two corner characters

    if (!left && !right) {
      return theme.fg("dim", "╭") + bc("─".repeat(fullWidth)) + theme.fg("dim", "╮");
    }

    // Each present segment is wrapped in a single space on each side: " content "
    const leftWidth = left ? visibleWidth(left) + 2 : 0;
    const rightWidth = right ? visibleWidth(right) + 2 : 0;
    const dashCount = fullWidth - leftWidth - rightWidth - 2; // -2 for the ─ pinned to each corner

    if (dashCount < 1) {
      // Terminal too narrow to show status — plain border
      return theme.fg("dim", "╭") + bc("─".repeat(fullWidth)) + theme.fg("dim", "╮");
    }

    const leftSegment  = left  ? " " + theme.fg("accent", left)  + " " : "";
    const rightSegment = right ? " " + theme.fg("accent", right) + " " : "";

    // Layout: ╭─ left content ──────────── right content ─╮
    return theme.fg("dim", "╭") + bc("─") + leftSegment + bc("─".repeat(dashCount)) + rightSegment + bc("─") + theme.fg("dim", "╮");
  }

  function setupCustomEditor(ctx: any): void {
    import("@mariozechner/pi-coding-agent").then(({ CustomEditor }) => {
      const editorFactory = (tui: any, editorTheme: any, keybindings: any) => {
        const editor = new CustomEditor(tui, editorTheme, keybindings);
        const originalRender = editor.render.bind(editor);

        editor.render = (width: number): string[] => {
          // Adjust width to account for the leading space added by the TUI
          const effectiveWidth = width - 1;
          if (effectiveWidth < 10) return originalRender(effectiveWidth);

          const theme = ctx.ui.theme;
          const bc = (s: string) => theme.fg("dim", s);

          // 3 chars left prefix (╰─  / │  ) + content + 2 chars right suffix ( │ / ─╯)
          const renderWidth = Math.max(1, effectiveWidth - 5);
          const lines = originalRender(renderWidth);
          if (lines.length === 0) return lines;

          // Pad a content line to renderWidth visible characters (ANSI-safe)
          const pad = (line: string) =>
            line + " ".repeat(Math.max(0, renderWidth - visibleWidth(line)));

          // Find the bottom border (scan backwards for a line of ─ characters)
          let bottomIdx = lines.length - 1;
          for (let i = lines.length - 1; i >= 1; i--) {
            const stripped = lines[i]?.replace(/\x1b\[[0-9;]*m/g, "") ?? "";
            if (stripped.length > 0 && /^─{3,}/.test(stripped)) { bottomIdx = i; break; }
          }

          const { left, right } = getStatusContent();
          const result: string[] = [buildTopBorder(effectiveWidth, left, right, theme, bc)];

          // Content lines (skip original top border at [0] and bottom border at bottomIdx).
          // Non-last lines get │ on both sides; the last (cursor) line gets ╰─  and ─╯.
          for (let i = 1; i < bottomIdx; i++) {
            const isLast = i === bottomIdx - 1;
            const prefix = isLast ? theme.fg("muted", "╰─ ") : theme.fg("dim",  "│  ");
            const suffix = isLast ? theme.fg("muted", "─╯")  : theme.fg("dim",  " │");
            result.push(`${prefix}${pad(lines[i] ?? "")}${suffix}`);
          }

          // Empty editor: add a blank prompt line so the cursor has somewhere to sit
          if (bottomIdx === 1) {
            result.push(`${theme.fg("muted", "╰─ ")}${" ".repeat(renderWidth)}${theme.fg("muted", "─╯")}`);
          }

          // Any autocomplete lines that follow the bottom border
          for (let i = bottomIdx + 1; i < lines.length; i++) {
            result.push(lines[i] ?? "");
          }

          return result;
        };

        return editor;
      };

      ctx.ui.setEditorComponent(editorFactory);
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Extension Setup
  // ═══════════════════════════════════════════════════════════════════════════

  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;

    // Reset session state
    state.cwd = ctx.cwd;
    state.tokens = undefined;
    state.contextWindow = undefined;
    state.modelId = undefined;
    gitCache = null;
    gitPending = null;
    gitGeneration = 0;
    tuiRef = ctx.ui;

    // Warm the git cache before first render
    const [branch, changes] = await Promise.all([fetchBranch(), fetchChanges()]);
    gitCache = {
      branch,
      staged: changes?.staged ?? 0,
      unstaged: changes?.unstaged ?? 0,
      untracked: changes?.untracked ?? 0,
      timestamp: Date.now(),
    };

    setupCustomEditor(ctx);

    // Clear the default footer — status lives in the editor border
    ctx.ui.setFooter(() => ({ render: () => [], invalidate: () => {} }));

    // Seed model/context info from the current session context
    try {
      const usage = ctx.getContextUsage?.();
      if (usage) state.tokens = usage.tokens ?? usage.tokensEstimated;
    } catch { /* ignore */ }

    try {
      const model = (ctx as any).model;
      if (model) {
        state.contextWindow = model.contextWindow ?? model.context ?? model.maxContext;
        state.modelId = model.id ?? model.modelId ?? model.name;
      }
    } catch { /* ignore */ }

    pi.on("model_select", async (event) => {
      try {
        state.modelId = event.model?.id;
        state.contextWindow = event.model?.contextWindow;
      } catch { /* ignore */ }
      requestRender();
    });

    pi.on("session_shutdown", async () => {
      ctx.ui.setEditorComponent(undefined);
      ctx.ui.setFooter(undefined);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Git Invalidation Events (no periodic polling)
  // ═══════════════════════════════════════════════════════════════════════════

  // Refresh token count after every LLM turn
  pi.on("turn_end", async (_event, ctx) => {
    try {
      const usage = ctx.getContextUsage?.();
      if (usage) state.tokens = usage.tokens ?? usage.tokensEstimated;
    } catch { /* ignore */ }
    requestRender();
  });

  pi.on("tool_result", async (event) => {
    if (event.toolName === "write" || event.toolName === "edit") {
      invalidateGitStatus();
      requestRender();
    }
  });

  pi.on("tool_call", async (event) => {
    if (event.toolName === "bash" && event.input?.command && mightChangeGitState(String(event.input.command))) {
      invalidateGitStatus();
      setTimeout(() => requestRender(), 100);
    }
  });

  pi.on("user_bash", async (event) => {
    if (mightChangeGitState(event.command)) {
      invalidateGitStatus();
      // Staggered re-renders to catch both fast and slow git operations
      setTimeout(() => requestRender(), 100);
      setTimeout(() => requestRender(), 300);
      setTimeout(() => requestRender(), 500);
    }
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Commands
  // ═══════════════════════════════════════════════════════════════════════════

  pi.registerCommand("status", {
    description: "Show current status info",
    handler: async (_args, ctx) => {
      const { left, right } = getStatusContent();
      ctx.ui.notify(`Status:\n  ${left}\n  ${right}`, "info");
    },
  });
}
