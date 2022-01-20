zmodload zsh/zprof
# measure large offenders with: `for i in $precmd_functions; do time (echo $i; $i >/dev/null); done`

# Displays a random tip from the .tips directory when opening the shell
# Requires gshuf (brew install coreutils)
#(
  #TIP_PATH=$(find -L ~/.tips -type f -name tips.txt | gshuf -n1) # Pick a random tips.txt file
  #TIP_TILE=${TIP_PATH#"$HOME/.tips/"}                            # i.e., ~/.tips/vim/vanilla/tips.txt  --->  vim/vanilla/tips.txt
  #echo "From ${TIP_TILE%.txt}:"                                  # i.e., "From vim/vanilla/tips:"
  #gshuf -n1 < "$TIP_PATH"                                        # Displays a random line from the tip file
#)

# Tracking how many ZSH shells I open
if [[ -o interactive ]] then
  echo $(date "+%Y-%m-%d %H:%M:%S") >> $HOME/.zsh-opens
fi

source ~/.zplug/init.zsh
zplugs=()
zplug "zplug/zplug"
zplug "plugins/brew-cask", from:oh-my-zsh, defer:2
zplug "plugins/jsontools", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "lib/spectrum", from:oh-my-zsh, ignore:oh-my-zsh.sh, use:"lib/spectrum.zsh" # Loads colours for themes
zplug "themes/nicoulaj", from:oh-my-zsh, as:theme
#if ! zplug check --verbose; then
  #printf "Install? [y/N]: "
  #if read -q; then
    #echo; zplug install
  #fi
#fi

zplug load

zstyle ':completion:*' menu select # Enabled the tab selection menu
setopt correct                     # Allows correction of typos in commands
unsetopt beep                      # Silience beeps
unsetopt nomatch                   # Makes glob matching same as bash (fixes the "zsh: no matches found" errors)

# Source z directory navigation
source `brew --prefix`/etc/profile.d/z.sh

# Source all the aliases
source "${ZDOTDIR:-$HOME}/.zaliases"

# Source all the exports
source "${ZDOTDIR:-$HOME}/.zexports"

# Source asdf
. $(brew --prefix asdf)/asdf.sh

# fzf integration
source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER=';'  # hit tab with an ending ; to open fzf
export FZF_DEFAULT_OPTS="-x -m --sort 100000 --layout reverse"
export FZF_DEFAULT_COMMAND='ag -g ""' # Use ag instead of find (faster and respects .gitignore)

# Config history settings
# Keeps only 100K commands in memory, but allows for 1B commands in history file
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
export HISTSIZE=100000           # Size of the history that is loaded in memory
export SAVEHIST=1000000000       # Size of the actual history file on disk
export HISTFILE=~/.zhistory      # File location for the history

#update-history() {
  #local currentDate
  #currentDate=$(date "+%Y-%m-%d")
  #if ! [ -s ~/.zlogs/complete-history-*.log ]
  #then
    #local completeHistoryFile
    #completeHistoryFile=~/.zlogs/complete-history-$currentDate.log

    #echo "Rebuilding $completeHistoryFile"
    #touch $completeHistoryFile
    #rm -f complete-history-*.log
    #create-complete-history > $completeHistoryFile
    #echo "$completeHistoryFile has $(wc -l $completeHistoryFile | awk '{print $1}') entries"

    #tail -n $HISTSIZE $completeHistoryFile > $HISTFILE
    #echo "Updated $HISTFILE to use last $HISTSIZE entries of $completeHistoryFile"
  #fi
#}
#update-history

#function complete-history-widget {
  #local selected
  #selected=($(complete-history))
  #BUFFER=$selected
  #zle redisplay
  #zle accept-line
#}
#zle -N complete-history-widget
#bindkey '^R' complete-history-widget

# Keep history of every shell command in a .zlogs directory under dated files (adapted from https://spin.atomicobject.com/2016/05/28/log-bash-history/)
preexec() {
  echo "$(date "+%Y-%m-%d %H:%M:%S")\t$(pwd)\t$1" >> ~/.zlogs/$(date "+%Y-%m-%d").log;
}

# Setting up TTY for GPG passphrase prompt
export GPG_TTY=$(tty)

# Use git-radar in right-prompt
export GIT_RADAR_FORMAT=" %{remote: }%{branch}%{ :local}%{ :changes}"
export RPROMPT="\$(git-radar --zsh --fetch) %{$FX[reset]%}"

# Move words with Alt+arrow
bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word

# Change history substring search colours (less 'flashy')
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=green,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback)
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

eval "$(direnv hook zsh)"

source /usr/local/opt/git-extras/share/git-extras/git-extras-completion.zsh

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/usr/local/heroku/bin"
export PATH="$HOME/.yarn/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# load dev, but only if present and the shell is interactive
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

if [ -e /Users/jalbert/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/jalbert/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
