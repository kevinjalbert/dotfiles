#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Disable beeps
unsetopt beep

# Make zsh glob matching behave same as bash
# This fixes the "zsh: no matches found" errors
unsetopt nomatch

# Source z directory navigation
source `brew --prefix`/etc/profile.d/z.sh

# Loads RVM into the shell's session
[[ -s "$HOME/.rvm/scripts/rvm"  ]] && . "$HOME/.rvm/scripts/rvm"

# Change ruby to 1.9.3 using RVM
rvm 1.9.3

# Tweak Ant to have more memory
export ANT_OPTS=-XX:PermSize=512m
