#!/bin/zsh
# Claude Code status line — enhanced dashboard (Tomorrow Light palette)
# Line 1: model | context% | cost | burn rate | cache ratio | daily cost
# Line 2: dir | worktree | branch + git status

# Tomorrow Light palette (RGB)
C_BLUE=$'\033[38;2;66;113;174m'     # #4271ae — model
C_GREEN=$'\033[38;2;113;140;0m'     # #718c00 — context (ok), branch
C_YELLOW=$'\033[38;2;234;183;0m'    # #eab700 — context (mid), worktree
C_ORANGE=$'\033[38;2;245;135;31m'   # #f5871f — cost, burn rate
C_RED=$'\033[38;2;200;40;41m'       # #c82829 — context (high), git dirty
C_CYAN=$'\033[38;2;62;153;159m'     # #3e999f — cache ratio
C_PURPLE=$'\033[38;2;137;89;168m'   # #8959a8 — daily/weekly/monthly
C_DIM=$'\033[38;2;142;144;140m'     # #8e908c — dim/secondary text
C_BOLD=$'\033[1m'
C_RESET=$'\033[0m'

# Nerd Font icons
ICON_TREE=$'\uF1BB'      # worktree
ICON_BRANCH=$'\uE725'    # git branch
ICON_CONTEXT=$'\uF080'   # context window (bar-chart)
ICON_COST=$'\uF155'       # cost/money
ICON_CACHE=$'\uF1C0'      # cache/database
ICON_MODEL=$'\uF2D0'      # model/chip
ICON_CALENDAR=$'\uF073'   # daily/weekly cost

COST_DIR="$HOME/.claude/cost-tracking"
COST_LOG="$COST_DIR/history.jsonl"
COST_CACHE="$COST_DIR/totals-cache.json"
CACHE_TTL=60

mkdir -p "$COST_DIR" 2>/dev/null

# Read JSON input from stdin
input=$(cat)

# --- Extract all JSON fields in one jq call ---
eval "$(echo "$input" | jq -r '
  @sh "model_name=\(.model.display_name // "")",
  @sh "used_pct=\(.context_window.used_percentage // "0")",
  @sh "session_cost=\(.cost.total_cost_usd // "0")",
  @sh "duration_ms=\(.cost.total_duration_ms // "0")",
  @sh "cache_write=\(.context_window.current_usage.cache_creation_input_tokens // "0")",
  @sh "cache_read=\(.context_window.current_usage.cache_read_input_tokens // "0")",
  @sh "input_tokens=\(.context_window.current_usage.input_tokens // "0")",
  @sh "session_id=\(.session_id // "")"
' 2>/dev/null)"

# ============================================================
# LINE 1: model, context, cost, burn rate, cache, daily
# ============================================================
line1=""
SEP="${C_DIM} | ${C_RESET}"

# --- Model ---
if [[ -n "$model_name" ]]; then
  line1="${C_BLUE}${ICON_MODEL} ${model_name}${C_RESET}"
fi

# --- Context window usage with visual bar ---
pct_int=$(printf "%.0f" "${used_pct:-0}")
used_fmt=$(printf "%.1f" "${used_pct:-0}")

# Pick color based on usage level
if (( pct_int >= 80 )); then
  ctx_color="$C_RED"
elif (( pct_int >= 50 )); then
  ctx_color="$C_YELLOW"
else
  ctx_color="$C_GREEN"
fi

filled=$(( pct_int / 10 ))
empty=$(( 10 - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

line1="${line1:+${line1}${SEP}}${ctx_color}${ICON_CONTEXT} ${bar} ${used_fmt}%${C_RESET}"

# --- Cache hit ratio ---
total_cache=$(( ${cache_read:-0} + ${cache_write:-0} + ${input_tokens:-0} ))
if [[ "$total_cache" -gt 0 ]]; then
  cache_pct=$(echo "scale=1; ${cache_read:-0} * 100 / $total_cache" | bc 2>/dev/null)
else
  cache_pct="0.0"
fi
line1="${line1:+${line1}${SEP}}${C_CYAN}${ICON_CACHE} ${cache_pct:-0.0}%${C_RESET}"

# --- Session cost ---
session_cost="${session_cost:-0}"
if [[ "$session_cost" == "0" || $(echo "$session_cost < 0.01" | bc -l 2>/dev/null) == "1" ]]; then
  if [[ "$session_cost" == "0" ]]; then
    cost_display="\$0.00"
  else
    cost_display="<\$0.01"
  fi
else
  cost_display="\$$(printf "%.2f" "$session_cost")"
fi
duration_ms="${duration_ms:-0}"
if [[ "$duration_ms" -gt 0 ]] 2>/dev/null; then
  burn_rate=$(echo "scale=6; ${session_cost} * 3600000 / $duration_ms" | bc 2>/dev/null)
  burn_fmt=$(printf "%.2f" "${burn_rate:-0}")
else
  burn_fmt="0.00"
fi
line1="${line1:+${line1}${SEP}}${C_ORANGE}${cost_display} (\$${burn_fmt}/hr)${C_RESET}"

# --- Persist cost for daily/weekly/monthly tracking ---
today=$(date +%Y-%m-%d)

# Only write to history when there's actual cost data
if [[ "$session_cost" != "0" && -n "$session_id" ]]; then
  stamp_file="$COST_DIR/.last-${session_id}"
  last_cost=""
  [[ -f "$stamp_file" ]] && last_cost=$(<"$stamp_file")
  if [[ "$last_cost" != "$session_cost" ]]; then
    echo "{\"date\":\"$today\",\"session_id\":\"$session_id\",\"cost\":$session_cost}" >> "$COST_LOG"
    echo -n "$session_cost" > "$stamp_file"
  fi
fi

# Recalculate totals cache if stale
recalc=false
if [[ ! -f "$COST_CACHE" ]] || [[ ! -s "$COST_CACHE" ]]; then
  recalc=true
else
  file_mtime=$(date -r "$COST_CACHE" +%s 2>/dev/null || echo 0)
  cache_age=$(( $(date +%s) - file_mtime ))
  (( cache_age > CACHE_TTL )) && recalc=true
fi

if $recalc && [[ -f "$COST_LOG" ]]; then
  week_ago=$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d '7 days ago' +%Y-%m-%d 2>/dev/null)
  month_ago=$(date -v-30d +%Y-%m-%d 2>/dev/null || date -d '30 days ago' +%Y-%m-%d 2>/dev/null)

  jq -s --arg today "$today" --arg week "$week_ago" --arg month "$month_ago" '
    group_by(.session_id) | map(max_by(.cost)) | . as $all |
    {
      daily: (([$all[] | select(.date == $today)] | map(.cost) | add) // 0),
      weekly: (([$all[] | select(.date >= $week)] | map(.cost) | add) // 0),
      monthly: (([$all[] | select(.date >= $month)] | map(.cost) | add) // 0)
    }
  ' "$COST_LOG" > "$COST_CACHE" 2>/dev/null

  if [[ -n "$month_ago" ]]; then
    jq -c --arg cutoff "$month_ago" 'select(.date >= $cutoff)' "$COST_LOG" > "${COST_LOG}.tmp" 2>/dev/null && \
      mv "${COST_LOG}.tmp" "$COST_LOG" 2>/dev/null
  fi

  find "$COST_DIR" -name '.last-*' -mtime +1 -delete 2>/dev/null
fi

# Always display daily/weekly/monthly — default to $0.00
daily=0 weekly=0 monthly=0
if [[ -f "$COST_CACHE" && -s "$COST_CACHE" ]]; then
  eval "$(jq -r '@sh "daily=\(.daily // 0)", @sh "weekly=\(.weekly // 0)", @sh "monthly=\(.monthly // 0)"' "$COST_CACHE" 2>/dev/null)"
fi
daily_fmt=$(printf "%.2f" "${daily:-0}")
weekly_fmt=$(printf "%.2f" "${weekly:-0}")
monthly_fmt=$(printf "%.2f" "${monthly:-0}")
line1="${line1:+${line1}${SEP}}${C_PURPLE}${ICON_CALENDAR} D:\$${daily_fmt} W:\$${weekly_fmt} M:\$${monthly_fmt}${C_RESET}"

# ============================================================
# LINE 2: dir, worktree, branch, git status
# ============================================================

# --- Git info: batch all git rev-parse calls into one ---
git_info=$(git --no-optional-locks rev-parse --show-toplevel --git-dir --git-common-dir 2>/dev/null)
if [[ -n "$git_info" ]]; then
  repo_root=$(sed -n '1p' <<< "$git_info")
  git_dir=$(sed -n '2p' <<< "$git_info")
  git_common=$(sed -n '3p' <<< "$git_info")
else
  repo_root="" git_dir="" git_common=""
fi

# --- Directory ---
dir=$(pwd)
if [[ -n "$repo_root" ]]; then
  if [[ "$dir" == "$repo_root" ]]; then
    dir=$(basename "$repo_root")
  elif [[ "$dir" == "$repo_root"/* ]]; then
    dir="${dir#"$repo_root"/}"
  fi
fi
IFS='/' read -rA parts <<< "$dir"
if (( ${#parts[@]} > 3 )); then
  dir="…/${parts[-3]}/${parts[-2]}/${parts[-1]}"
fi

# Directory: bold blue (matches starship [directory])
line2="${C_BOLD}${C_BLUE}${dir}${C_RESET}"

# --- Worktree name: bold cyan (matches starship [custom.worktree]) ---
if [[ -n "$git_dir" && -n "$git_common" && "$git_dir" != "$git_common" ]]; then
  # If multiple worktrees share the same basename (e.g., all named "src"),
  # use the parent directory name instead
  worktree_name=$(basename "$repo_root")
  dup_count=$(git worktree list --porcelain | awk -v n="$worktree_name" '/^worktree /{sub(".*/",""); if($0==n) c++} END{print c+0}')
  if [[ "$dup_count" -gt 1 ]]; then
    worktree_name=$(basename "$(dirname "$repo_root")")
  fi
  line2="$line2  ${C_BOLD}${C_CYAN}${ICON_TREE} ${worktree_name}${C_RESET}"
fi

# --- Git branch: bold purple (matches starship [git_branch]) ---
branch=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
if [[ -n "$branch" ]]; then
  line2="$line2  ${C_BOLD}${C_PURPLE}${ICON_BRANCH} ${branch}${C_RESET}"
fi

# --- Git status: per-item colors (matches starship [git_status]) ---
gst=""
ahead=$(git --no-optional-locks rev-list --count @{upstream}..HEAD 2>/dev/null)
behind=$(git --no-optional-locks rev-list --count HEAD..@{upstream} 2>/dev/null)
[[ "$ahead" -gt 0 ]] 2>/dev/null && gst+="⇡${ahead}"
[[ "$behind" -gt 0 ]] 2>/dev/null && gst+="⇣${behind}"

if git_status=$(git --no-optional-locks status --porcelain 2>/dev/null); then
  staged=0 modified=0 untracked=0
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    x="${line:0:1}" y="${line:1:1}"
    [[ "$x" == "?" ]] && (( untracked++ )) && continue
    [[ "$x" != " " && "$x" != "?" ]] && (( staged++ ))
    [[ "$y" != " " && "$y" != "?" ]] && (( modified++ ))
  done <<< "$git_status"

  # Color each indicator to match starship: staged=green, modified=orange, untracked=comment
  [[ "$staged" -gt 0 ]] && gst+="${C_GREEN}+${staged}${C_RESET}"
  [[ "$modified" -gt 0 ]] && gst+="${C_ORANGE}!${modified}${C_RESET}"
  [[ "$untracked" -gt 0 ]] && gst+="${C_DIM}?${untracked}${C_RESET}"
fi

if [[ -n "$gst" ]]; then
  line2="$line2 ${C_DIM}(${C_RESET}${gst}${C_DIM})${C_RESET}"
fi

# ============================================================
# Output
# ============================================================
echo "$line1"
echo "$line2"
