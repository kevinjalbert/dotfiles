" Use vim settings instead of vi
set nocompatible

" Set default shell to be zsh
set shell=/bin/zsh

" Enable python (https://ricostacruz.com/til/neovim-with-python-on-osx)
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Speed up ESC from insert
set ttimeoutlen=50

" Reload files changed outside vim
set autoread

" Automatically detect file types
filetype plugin indent on
au BufNewFile,BufRead *.es6 set filetype=javascript
au BufReadPost *.handlebars,*.hbs set filetype=html syntax=mustache

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

" Show the file in the terminal title
set title

" Enable mouse within terminal
set mouse=a

" Set relative numbers
" Handled by myusuf3/numbers.vim

" Make command line tab complete with cycling
set wildmode=full
set wildmenu
set wildignore=*.o,*.obj,*~

" Map new leader (,) and localleader (\)
let mapleader = ","
let maplocalleader = "\\"
