let g:vim_home = '~/.config/nvim/'
let g:editor_root=expand("~/.config/nvim/")

let s:config_list = [
  \ 'settings.vim',
  \ 'plugins.vim',
  \ 'theme.vim',
  \ 'plugin_settings/*.vim',
  \ 'functions.vim',
  \ 'leader.vim',
  \ 'keymappings.vim',
\]

for files in s:config_list
  for f in split(glob(vim_home.files), '\n')
    exec 'source '.f
  endfor
endfor
