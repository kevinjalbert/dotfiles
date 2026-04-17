/**
 * Persistent Prompt History — pi extension
 *
 * Saves every submitted prompt to a SQLite database (~/.pi/agent/prompt-history.db)
 * and provides a Ctrl+R fuzzy-search overlay to recall them across sessions.
 *
 * Features:
 *   • SQLite-backed with FTS5 full-text search (node:sqlite built-in, no deps)
 *   • Ctrl+R opens an incremental search overlay
 *   • Up/Down arrows navigate results; Enter injects the selection into the editor
 *   • Deduplicates consecutive identical prompts
 *   • Stores CWD per entry for future per-project filtering
 */

// Uses sqlite3 CLI since node:sqlite is not available in Node < 22.5
import { execSync, spawnSync } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { DynamicBorder } from "@mariozechner/pi-coding-agent";
import {
  Container,
  type Component,
  type Focusable,
  Input,
  matchesKey,
  Spacer,
  Text,
  truncateToWidth,
} from "@mariozechner/pi-tui";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

// ─── Types ────────────────────────────────────────────────────────────────────

interface HistoryEntry {
  id: number;
  prompt: string;
  created_at: number;
  cwd: string | null;
}

// Minimal Theme interface — we only use the subset we need
interface Theme {
  fg(color: string, text: string): string;
  bold(text: string): string;
}

// ─── Database ─────────────────────────────────────────────────────────────────

const DB_PATH = path.join(os.homedir(), ".pi", "agent", "prompt-history.db");

class HistoryDB {
  #dbPath: string;
  #lastPromptCache: string | null = null;

  constructor(dbPath: string = DB_PATH) {
    this.#dbPath = dbPath;
    fs.mkdirSync(path.dirname(dbPath), { recursive: true });

    this.#exec(`
      PRAGMA journal_mode=WAL;
      PRAGMA synchronous=NORMAL;
      PRAGMA busy_timeout=5000;

      CREATE TABLE IF NOT EXISTS history (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        prompt     TEXT    NOT NULL,
        created_at INTEGER NOT NULL
                           DEFAULT (CAST(strftime('%s','now') AS INTEGER)),
        cwd        TEXT
      );

      CREATE INDEX IF NOT EXISTS idx_history_created_at
        ON history(created_at DESC);

      CREATE VIRTUAL TABLE IF NOT EXISTS history_fts
        USING fts5(prompt, content='history', content_rowid='id');

      CREATE TRIGGER IF NOT EXISTS history_ai
        AFTER INSERT ON history BEGIN
          INSERT INTO history_fts(rowid, prompt) VALUES (new.id, new.prompt);
        END;
    `);

    // Seed FTS index on first run (in case table existed without FTS)
    try {
      const count = this.#query<{ n: number }>("SELECT count(*) AS n FROM history_fts")[0];
      if (!count || count.n === 0) {
        this.#exec("INSERT INTO history_fts(history_fts) VALUES('rebuild')");
      }
    } catch {
      // FTS rebuild is best-effort
    }

    const last = this.#query<{ prompt: string }>("SELECT prompt FROM history ORDER BY id DESC LIMIT 1")[0];
    this.#lastPromptCache = last?.prompt ?? null;
  }

  #exec(sql: string): void {
    spawnSync("sqlite3", [this.#dbPath, sql], { stdio: "ignore" });
  }

  #query<T>(sql: string, params: string[] = []): T[] {
    const args = ["-json", this.#dbPath];
    // For parameterized queries with sqlite3 CLI, we can't easily do it with positional params 
    // unless we escape them carefully. Since we need this to be simple and safe, 
    // we'll use a slightly different approach for the search.
    // For now, let's just use the query as is for simple things.
    const proc = spawnSync("sqlite3", [...args, sql], { encoding: "utf8" });
    if (proc.status !== 0 || !proc.stdout.trim()) return [];
    try {
      return JSON.parse(proc.stdout);
    } catch {
      return [];
    }
  }

  /** Persist a prompt. Silently deduplicates consecutive identical entries. */
  add(prompt: string, cwd?: string): void {
    const trimmed = prompt.trim();
    if (!trimmed || this.#lastPromptCache === trimmed) return;
    this.#lastPromptCache = trimmed;
    
    const promptHex = Buffer.from(trimmed).toString("hex");
    const cwdHex = Buffer.from(cwd ?? "").toString("hex");
    this.#exec(`INSERT INTO history (prompt, cwd) VALUES (x'${promptHex}', x'${cwdHex}');`);
  }

  /** Return the most-recent \`limit\` entries (max 1 000). */
  getRecent(limit = 100): HistoryEntry[] {
    return this.#query<HistoryEntry>(
      `SELECT id, prompt, created_at, cwd
         FROM history
        ORDER BY created_at DESC, id DESC
        LIMIT ${Math.min(limit, 1000)}`
    );
  }

  /**
   * Full-text search via FTS5.
   * Each whitespace-delimited token becomes a prefix match: \`"tok"*\`
   * Falls back to getRecent when query is empty or search throws.
   */
  search(query: string, limit = 100): HistoryEntry[] {
    const q = this.#buildFtsQuery(query);
    if (!q) return this.getRecent(limit);
    
    const qHex = Buffer.from(q).toString("hex");
    return this.#query<HistoryEntry>(
      `SELECT h.id, h.prompt, h.created_at, h.cwd
         FROM history_fts f
         JOIN history h ON h.id = f.rowid
        WHERE history_fts MATCH x'${qHex}'
        ORDER BY h.created_at DESC, h.id DESC
        LIMIT ${Math.min(limit, 1000)}`
    );
  }

  #buildFtsQuery(query: string): string | null {
    const tokens = query.trim().split(/\s+/).filter(Boolean);
    if (tokens.length === 0) return null;
    // Prefix-match every token so "git comm" finds "git commit ..."
    return tokens.map((t) => `"${t.replace(/"/g, '""')}"`+ "*").join(" ");
  }
}

// ─── History Results List Component ──────────────────────────────────────────

interface ResultItem {
  value: string;
  label: string;
}

class HistoryResultsList implements Component {
  #items: ResultItem[] = [];
  #selectedIdx = 0;
  readonly #maxVisible: number;

  onSelect?: (item: ResultItem) => void;
  onCancel?: () => void;

  constructor(maxVisible = 12) {
    this.#maxVisible = maxVisible;
  }

  setItems(items: ResultItem[], resetSelection = true): void {
    this.#items = items;
    if (resetSelection) {
      this.#selectedIdx = 0;
    } else {
      this.#selectedIdx = Math.min(
        this.#selectedIdx,
        Math.max(0, items.length - 1),
      );
    }
  }

  getSelected(): ResultItem | null {
    return this.#items[this.#selectedIdx] ?? null;
  }

  moveUp(): void {
    if (this.#items.length === 0) return;
    this.#selectedIdx = Math.max(0, this.#selectedIdx - 1);
  }

  moveDown(): void {
    if (this.#items.length === 0) return;
    this.#selectedIdx = Math.min(this.#items.length - 1, this.#selectedIdx + 1);
  }

  invalidate(): void {}

  render(width: number): string[] {
    if (this.#items.length === 0) {
      return ["  \x1b[2mNo matching history\x1b[0m"];
    }

    const half = Math.floor(this.#maxVisible / 2);
    const start = Math.max(
      0,
      Math.min(this.#selectedIdx - half, this.#items.length - this.#maxVisible),
    );
    const end = Math.min(start + this.#maxVisible, this.#items.length);

    const lines: string[] = [];
    for (let i = start; i < end; i++) {
      const item = this.#items[i]!;
      const isSel = i === this.#selectedIdx;
      // 2-char cursor gutter
      const cursor = isSel ? "\x1b[36m›\x1b[0m " : "  ";
      const normalized = item.label.replace(/\s+/g, " ").trim();
      const body = truncateToWidth(normalized, width - 2);
      lines.push(cursor + (isSel ? `\x1b[1m${body}\x1b[0m` : body));
    }

    if (this.#items.length > this.#maxVisible) {
      const info = `  (${this.#selectedIdx + 1}/${this.#items.length})`;
      lines.push(`\x1b[2m${truncateToWidth(info, width)}\x1b[0m`);
    }

    return lines;
  }
}

// ─── History Search Dialog ────────────────────────────────────────────────────

class HistorySearchDialog extends Container implements Focusable {
  readonly #db: HistoryDB;
  readonly #tui: { requestRender(): void };
  readonly #input: Input;
  readonly #list: HistoryResultsList;
  readonly #footer: Text;

  // Focusable — propagate to Input so the IME cursor lands in the right spot
  private _focused = false;
  get focused(): boolean {
    return this._focused;
  }
  set focused(val: boolean) {
    this._focused = val;
    this.#input.focused = val;
  }

  onSelect?: (prompt: string) => void;
  onCancel?: () => void;

  constructor(
    db: HistoryDB,
    tui: { requestRender(): void },
    theme: Theme,
  ) {
    super();
    this.#db = db;
    this.#tui = tui;

    // Build child tree
    this.#input = new Input();
    this.#input.onSubmit = () => this.#confirmSelection();
    this.#input.onEscape = () => this.onCancel?.();

    this.#list = new HistoryResultsList(12);
    this.#list.onSelect = (item) => this.onSelect?.(item.value);
    this.#list.onCancel = () => this.onCancel?.();

    this.#footer = new Text(
      theme.fg("dim", "  ↑↓ navigate   enter select   esc cancel"),
      0,
      0,
    );

    this.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));
    this.addChild(
      new Text(
        "  " +
          theme.bold("Prompt History") +
          "  " +
          theme.fg("dim", "ctrl+r"),
        0,
        0,
      ),
    );
    this.addChild(new Spacer(1));
    this.addChild(this.#input);
    this.addChild(new Spacer(1));
    this.addChild(this.#list);
    this.addChild(new Spacer(1));
    this.addChild(this.#footer);
    this.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));

    this.#refresh();
  }

  handleInput(data: string): void {
    if (matchesKey(data, "up")) {
      this.#list.moveUp();
      this.#tui.requestRender();
    } else if (matchesKey(data, "down")) {
      this.#list.moveDown();
      this.#tui.requestRender();
    } else if (matchesKey(data, "enter") || data === "\r" || data === "\n") {
      this.#confirmSelection();
    } else if (matchesKey(data, "escape")) {
      this.onCancel?.();
    } else {
      this.#input.handleInput(data);
      this.#refresh();
      this.#tui.requestRender();
    }
  }

  #confirmSelection(): void {
    const sel = this.#list.getSelected();
    if (sel) {
      this.onSelect?.(sel.value);
    } else {
      // Nothing in list yet — submit whatever is typed
      const typed = this.#input.getValue().trim();
      if (typed) this.onSelect?.(typed);
    }
  }

  #refresh(): void {
    const q = this.#input.getValue().trim();
    const entries = q
      ? this.#db.search(q, 100)
      : this.#db.getRecent(100);
    this.#list.setItems(
      entries.map((e) => ({
        value: e.prompt,
        label: e.prompt.replace(/\s+/g, " ").trim(),
      })),
    );
  }
}

// ─── Extension Entry Point ────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
  // Lazy-open DB so startup isn't blocked if SQLite init is slow
  let db: HistoryDB | null = null;

  function getDb(): HistoryDB {
    if (!db) db = new HistoryDB();
    return db;
  }

  // ── 1. Save every submitted prompt ────────────────────────────────────────
  pi.on("before_agent_start", (event, ctx) => {
    try {
      getDb().add(event.prompt, ctx.cwd);
    } catch {
      // Never let history writes crash the agent
    }
  });

  // ── 2. Ctrl+R → history search overlay ────────────────────────────────────
  pi.registerShortcut("ctrl+r", {
    description: "Search prompt history",
    handler: async (ctx) => {
      if (!ctx.hasUI) return;

      const selectedPrompt = await ctx.ui.custom<string | null>(
        (tui, theme, _kb, done) => {
          const dialog = new HistorySearchDialog(getDb(), tui, theme);
          dialog.onSelect = (prompt) => done(prompt);
          dialog.onCancel = () => done(null);
          return dialog;
        },
      );

      if (selectedPrompt !== null) {
        ctx.ui.setEditorText(selectedPrompt);
      }
    },
  });
}
