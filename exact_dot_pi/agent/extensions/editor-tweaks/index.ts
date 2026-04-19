import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isKeyRelease, matchesKey } from "@mariozechner/pi-tui";

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (!ctx.hasUI) return;

    ctx.ui.onTerminalInput((data) => {
      // Ignore key-release events so one physical Esc doesn't get processed twice
      // in terminals that emit Kitty key press/release pairs.
      if (isKeyRelease(data)) return;

      if (!matchesKey(data, "escape")) return;

      // Keep built-in Esc behavior while agent is busy (interrupt/abort).
      if (!ctx.isIdle()) return;

      const current = ctx.ui.getEditorText();

      // If editor is empty, do not consume. This preserves built-in empty-editor
      // double-Esc behavior (tree/fork/none).
      if (!current) return;

      // Idle + non-empty editor: treat Esc as clear-editor (Ctrl+C-like clear).
      ctx.ui.setEditorText("");

      // Consume so this Esc doesn't fall through to app.interrupt handling.
      return { consume: true };
    });
  });
}
