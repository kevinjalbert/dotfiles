" Use vim settings instead of vi
set nocompatible

" Set default shell to be bash
set shell=/bin/sh

" Speed up ESC from insert
set ttimeoutlen=50

" Reload files changed outside vim
set autoread

" Automatically detect file types
filetype plugin indent on
au BufNewFile,BufRead *.es6 set filetype=javascript

" Turn off null characters
imap <Nul> <Space>
imap <Nul> <Nop>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>

" Increase tty redraw speed
set ttyfast
set lazyredraw

" Enable backspacing over everything in insert mode
set backspace=indent,eol,start

" Enable syntax highlighting
syntax on

" Enable mouse within terminal
set mouse=a
set ttymouse=xterm2

" Make command line tab complete with cycling
set wildmode=full
set wildmenu
set wildignore=*.o,*.obj,*~
