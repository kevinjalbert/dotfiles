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
 *
 * Responsive behavior (2026-04-23):
 * - Right side (model + context) is high-priority and preserved even at narrow widths
 * - Left side (directory + git) gets dropped/truncated first when space is tight
 * - Directory paths progressively shorten; very long paths middle-truncated with ellipsis
 * - Context bar drops when width < 90 cols; both sides drop when < 50 cols
 */

import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";
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
        if (gen !== gitGeneration) return;
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
    gitPending = null;
    gitGeneration++;
  }

  function mightChangeGitState(cmd: string): boolean {
    return [
      /\bgit\s+(checkout|switch|branch\s+-[dDmM]|merge|rebase|pull|reset|worktree)/,
      /\bgit\s+stash\s+(pop|apply)/,
    ].some((p) => p.test(cmd));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Responsive Segment Selection
  // ═══════════════════════════════════════════════════════════════════════════

  // Aggressively shorten paths while respecting directory boundaries
  function shortenHome(p: string, maxLength: number = 35): string {
    const home = homedir();
    let path = p;

    // Expand $HOME to "~"
    if (path === home) return "~";
    if (path.startsWith(home + "/") || path.startsWith(home + "\\")) {
      path = "~" + path.slice(home.length);
    }

    // Already fits — return as-is
    if (visibleWidth(path) <= maxLength) return path;

    // Split into directory components (preserve the leading "~" segment)
    const parts = path.split(/[\\/]/); // Handles both / and \
    if (parts.length <= 1) {
      return truncateToWidth(path, maxLength, "…");
    }

    const ellipsis = "…";

    // Keep the last segment (current directory) fully intact whenever possible.
    // Try progressive aggregations from narrow → wide: 
    //   ~/…/last         (just current dir)
    //   ~/parent/…/last  (one level up)
    //   ~/p1/p2/…/last  (two levels up)
    //   … etc up to full path
    const candidates: string[] = [];
    const last = parts[parts.length - 1];

    // Always include ~/…/last
    candidates.push(`~${ellipsis}/${last}`);

    // Add candidates with increasing number of parent directories on the left
    for (let i = parts.length - 2; i >= 1; i--) {
      const kept = parts.slice(i).join("/");
      candidates.push(`~${ellipsis}/${kept}`);
    }

    // Finally, the full path (no ellipsis)
    candidates.push(path);

    // Return the first (i.e. shortest) candidate that fits
    for (const candidate of candidates) {
      if (visibleWidth(candidate) <= maxLength) {
        return candidate;
      }
    }

    // Nothing fits — extreme fallback: truncate current dir itself
    if (maxLength >= visibleWidth(last) + 2) {
      return `~/${last}`;
    }
    if (maxLength >= 2) {
      return "~" + truncateToWidth(last, maxLength - 1, "");
    }
    return "~";
  }

  // Build git status string
  function renderGitSegment(): string {
    const git = getGitStatus();
    if (!git.branch && git.staged === 0 && git.unstaged === 0 && git.untracked === 0) return "";
    const dirtyParts: string[] = [];
    if (git.unstaged  > 0) dirtyParts.push(`\uF040${git.unstaged}`);  //  pencil
    if (git.staged    > 0) dirtyParts.push(`\uF067${git.staged}`);   //  plus
    if (git.untracked > 0) dirtyParts.push(`\uF128${git.untracked}`); //  ?
    const dirty = dirtyParts.length > 0 ? ` (${dirtyParts.join(" ")})` : "";
    return git.branch ? `\uE0A0 ${git.branch}${dirty}` : dirty.trim();
  }

  // Build context usage bar
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

  // Choose which segments to show based on available width.
  // Priority (dropped first → last): context bar, directory, git, model.
  function getSegmentsForWidth(avail: number): { left: string; right: string } {
    const gitStr   = renderGitSegment();
    const modelRaw = state.modelId || "";
    const modelStr = modelRaw.includes("/") ? modelRaw.split("/").pop()! : modelRaw; // strip provider
    const ctxStr   = renderContextSegment();

    // Start with full content
    let left  = shortenHome(state.cwd || "?", 35);
    if (gitStr) left += " " + gitStr;
    let right = modelStr;
    if (ctxStr) right += " " + ctxStr;

    const leftW  = visibleWidth(left)  + 2; // padding
    const rightW = visibleWidth(right) + 2;
    const usable = avail - 2; // for pinned dashes

    // ── Everything fits ──
    if (leftW + rightW <= usable) return { left, right };

    // ── CONTEXT DROPS FIRST (when width < 90) ──
    if (ctxStr && avail < 90) {
      right = modelStr;
      const newRightW = visibleWidth(right) + 2;
      if (leftW + newRightW <= usable) {
        return { left, right: modelStr };
      }
    }

    // Re-measure after dropping context
    const rightPostCtxW = visibleWidth(right) + 2;

    // ── STILL TOO WIDE? Drop/truncate LEFT (directory first, then git) ──
    if (leftW + rightPostCtxW > usable) {
      // Try: drop directory, keep git only
      if (gitStr) {
        const gitOnlyW = visibleWidth(gitStr) + 2;
        if (gitOnlyW + rightPostCtxW <= usable) {
          return { left: gitStr, right };
        }
      }
      // Try: git-only but still too wide → truncate left aggressively
      const maxLeft = usable - rightPostCtxW;
      if (maxLeft >= 7) {
        const truncated = truncateToWidth(left, maxLeft - 2, "…");
        return { left: truncated, right };
      }
      // Left can't fit at all → drop left
      return { left: "", right };
    }

    // ── Left fits with current right ──
    return { left, right };
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

  // Build the top border line
  // Structure: ╭─ left-pad ───── gap ───── right-pad ─╮
  function buildTopBorder(width: number, left: string, right: string, theme: any, bc: (s: string) => string): string {
    const fullWidth = width - 2;

    if (!left && !right) {
      return theme.fg("dim", "╭") + bc("─".repeat(fullWidth)) + theme.fg("dim", "╮");
    }

    const leftW  = left  ? visibleWidth(left)  + 2 : 0;
    const rightW = right ? visibleWidth(right) + 2 : 0;
    const usable = fullWidth - 2;
    let gap = usable - leftW - rightW;

    if (gap < 0) {
      console.warn("Status line overflow — dropping status display", { left, leftW, right, rightW, usable, gap });
      return theme.fg("dim", "╭") + bc("─".repeat(fullWidth)) + theme.fg("dim", "╮");
    }

    const leftSeg  = left  ? " " + theme.fg("accent", left)  + " " : "";
    const rightSeg = right ? " " + theme.fg("accent", right) + " " : "";

    return (
      theme.fg("dim", "╭") +
      bc("─") +
      leftSeg +
      bc("─".repeat(gap)) +
      rightSeg +
      bc("─") +
      theme.fg("dim", "╮")
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Editor Component (Rounded Box Design)
  // ═══════════════════════════════════════════════════════════════════════════

  function setupCustomEditor(ctx: any): void {
    import("@mariozechner/pi-coding-agent").then(({ CustomEditor }) => {
      const editorFactory = (tui: any, editorTheme: any, keybindings: any) => {
        const editor = new CustomEditor(tui, editorTheme, keybindings);
        const originalRender = editor.render.bind(editor);

        editor.render = (width: number): string[] => {
          const effectiveWidth = width - 1;
          if (effectiveWidth < 10) return originalRender(effectiveWidth);

          const theme = ctx.ui.theme;
          const bc = (s: string) => theme.fg("dim", s);
          const renderWidth = Math.max(1, effectiveWidth - 5);
          const lines = originalRender(renderWidth);
          if (lines.length === 0) return lines;

          const pad = (line: string) =>
            line + " ".repeat(Math.max(0, renderWidth - visibleWidth(line)));

          // Find bottom border (first line from bottom that is mostly ─ chars)
          let bottomIdx = lines.length - 1;
          for (let i = lines.length - 1; i >= 1; i--) {
            const stripped = lines[i]?.replace(/\x1b\[[0-9;]*m/g, "") ?? "";
            if (stripped && /^─{3,}/.test(stripped)) { bottomIdx = i; break; }
          }

          // Compute segments for current width
          const statusAvail = effectiveWidth - 2;
          const { left, right } = getSegmentsForWidth(statusAvail);

          // If nothing to render, just return the plain editor
          const hasAny = left.length > 0 || right.length > 0;
          if (!hasAny) {
            return lines;
          }

          const result: string[] = [buildTopBorder(effectiveWidth, left, right, theme, bc)];

          for (let i = 1; i < bottomIdx; i++) {
            const isLast = i === bottomIdx - 1;
            const prefix = isLast ? theme.fg("muted", "╰─ ") : theme.fg("dim",  "│  ");
            const suffix = isLast ? theme.fg("muted", "─╯")  : theme.fg("dim",  " │");
            result.push(`${prefix}${pad(lines[i] ?? "")}${suffix}`);
          }

          if (bottomIdx === 1) {
            result.push(`${theme.fg("muted", "╰─ ")}${" ".repeat(renderWidth)}${theme.fg("muted", "─╯")}`);
          }

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

    state.cwd = ctx.cwd;
    state.tokens = undefined;
    state.contextWindow = undefined;
    state.modelId = undefined;
    gitCache = null;
    gitPending = null;
    gitGeneration = 0;
    tuiRef = ctx.ui;

    // Warm git cache
    const [branch, changes] = await Promise.all([fetchBranch(), fetchChanges()]);
    gitCache = {
      branch,
      staged: changes?.staged ?? 0,
      unstaged: changes?.unstaged ?? 0,
      untracked: changes?.untracked ?? 0,
      timestamp: Date.now(),
    };

    setupCustomEditor(ctx);
    ctx.ui.setFooter(() => ({ render: () => [], invalidate: () => {} }));

    // Seed model/context from session
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
  // Git & Context Invalidation
  // ═══════════════════════════════════════════════════════════════════════════

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
      setTimeout(() => requestRender(), 100);
      setTimeout(() => requestRender(), 300);
      setTimeout(() => requestRender(), 500);
    }
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Commands
  // ═══════════════════════════════════════════════════════════════════════════

  pi.registerCommand("status", {
    description: "Show current status info (debug)",
    handler: async (_args, ctx) => {
      const { left, right } = getSegmentsForWidth(120);
      ctx.ui.notify(`Status:\n  Left:  ${left || "(empty)"}\n  Right: ${right || "(empty)"}`, "info");
    },
  });
}
