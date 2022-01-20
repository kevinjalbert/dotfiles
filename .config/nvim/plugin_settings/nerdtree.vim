if !isdirectory($HOME . "/.config/nvim/plugged/nerdtree")
  finish
endif

let g:NERDTreeChDirMode=2
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40

let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
