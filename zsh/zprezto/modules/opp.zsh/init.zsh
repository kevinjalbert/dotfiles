# Enable Vim Mode
bindkey -v

# Add alterntive escape (jk) from insert mode
bindkey -M viins 'jk' vi-cmd-mode

# Add alternative way to search (,f)
bindkey ',f' history-incremental-search-backward

# Search history using up/down arrow
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Change the cursor to indicate mode
function zle-keymap-select zle-line-init
{
  # Change cursor shape in iTerm2
  case $KEYMAP in
    vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
    viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
  esac

  zle reset-prompt
  zle -R
}
zle -N zle-line-init
zle -N zle-keymap-select

# Change the cursor to indicate mode
function zle-line-finish
{
  print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}
zle -N zle-line-finish

# Add a command :q or :Q to quit the shell when in command mode
function ft-zshexit {
    [[ -o hist_ignore_space ]] && BUFFER=' '
    BUFFER="${BUFFER}exit"
    zle .accept-line
}
zle -N q ft-zshexit
zle -N Q ft-zshexit

# Add Vim's text-objects-ish
source ~/.zprezto/modules/opp.zsh/opp.zsh
source ~/.zprezto/modules/opp.zsh/opp/*.zsh
