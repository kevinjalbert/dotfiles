# Claude Code Status Line

A custom two-line status line for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that displays session metrics and git context.

## Layout

**Line 1** — Session metrics:

```
 Model |  ████░░░░░░ 42.1% |  67.3% |  $1.23 ($4.56/hr) |  D:$3.21 W:$18.40 M:$52.10
```

| Segment | Description |
|---------|-------------|
| Model | Active Claude model name |
| Context | Visual bar + percentage of context window used (green/yellow/red) |
| Cache | Cache read hit ratio as percentage of total input tokens |
| Cost | Session cost + burn rate ($/hr) |
| Daily/Weekly/Monthly | Rolling cost totals (persisted to `~/.claude/cost-tracking/`) |

**Line 2** — Working directory and git:

```
areas/platforms/shipify   root   main (⇡1+2!1?3)
```

| Segment | Description |
|---------|-------------|
| Directory | Current path relative to repo root (truncated to 3 segments) |
| Worktree | Git worktree name (shown only when in a worktree) |
| Branch | Current branch or short SHA |
| Git status | Ahead/behind, staged (+), modified (!), untracked (?) counts |

## Setup

1. **Symlink the script** so Claude Code can find it at its expected path:

   ```bash
   ln -sf /path/to/dotfiles/claude-code/statusline-command.sh ~/.claude/statusline-command.sh
   ```

2. **Configure Claude Code** by adding this to `~/.claude/settings.json`:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "zsh ~/.claude/statusline-command.sh"
     }
   }
   ```

   > **Note:** If `~` doesn't resolve in your shell, use the full `$HOME` path (e.g., `zsh /Users/<you>/.claude/statusline-command.sh`).

## Requirements

- **Nerd Font** — icons use Nerd Font glyphs (e.g., ``, ``, ``)
- **jq** — JSON parsing for session data and cost tracking
- **bc** — arithmetic for percentages and burn rate
- **zsh** — script uses zsh-specific syntax (`read -rA`, arithmetic)

## Color Palette

Uses the [Tomorrow Light](https://github.com/chriskempson/tomorrow-theme) palette for consistency with terminal themes:

| Color | Hex | Usage |
|-------|-----|-------|
| Blue | `#4271ae` | Model, directory |
| Green | `#718c00` | Context (ok), branch, staged |
| Yellow | `#eab700` | Context (mid), worktree |
| Orange | `#f5871f` | Cost, burn rate, modified |
| Red | `#c82829` | Context (high) |
| Cyan | `#3e999f` | Cache ratio |
| Purple | `#8959a8` | Daily/weekly/monthly, branch |
| Dim | `#8e908c` | Separators, untracked |
