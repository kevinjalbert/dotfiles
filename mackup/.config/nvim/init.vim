" ----------------------------------------------------------------------------
" My personal Vim configuration using Vundle for plugins
"
" Bits and pieces of this configuration are adapted from the two amazing
" vim configurations of scrooloose/vimfiles and astrails/dotvim from their
" GitHub repositories.
"
" Author: Kevin Jalbert <kevin.j.jalbert@gmail.com>
" ----------------------------------------------------------------------------

let g:vim_home = '~/.config/nvim/'
let g:editor_root=expand("~/.config/nvim/")

let s:config_list = [
  \ 'base.vim',
  \ 'plugins.vim',
  \ 'functions.vim',
  \ 'theme.vim',
  \ 'settings.vim',
  \ 'leader.vim',
  \ 'keymappings.vim',
  \ 'languages.vim',
  \ 'plugin_settings/*.vim'
\]

for files in s:config_list
  for f in split(glob(vim_home.files), '\n')
    exec 'source '.f
  endfor
endfor
