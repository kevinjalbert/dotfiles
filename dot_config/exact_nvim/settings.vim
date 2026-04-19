" Use vim settings instead of vi
set nocompatible

" Set default shell to be zsh
set shell=/bin/zsh

" Speed up ESC from insert
set ttimeoutlen=50

" Reload files changed outside vim
set autoread

" Automatically detect file types
filetype plugin indent on

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

" Map new leader (,) and localleader (\)
let mapleader = ","
let maplocalleader = "\\"

" Automatically rebalance windows when resizing vim
autocmd VimResized * :wincmd =

" Storage for :cmdline history
set history=1000

" Shows incomplete commands in statusline
set showcmd

" Shows current mode in statusline
set showmode

" Undo settings
execute "set undodir=" . g:vim_home . 'undofiles'
set undofile

" Turn backup off
set nobackup
set nowb
set noswapfile

" Use incsearch.vim for all search functions (with anzu for indication)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#auto_nohlsearch = 1
set hlsearch
set ignorecase
set smartcase
map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
map * <Plug>(incsearch-nohl)<Plug>(anzu-star-with-echo)
map # <Plug>(incsearch-nohl)<Plug>(anzu-sharp-with-echo)
let g:airline#extensions#anzu#enabled = 0
let g:anzu_status_format = "%p(%i/%l) %w"

" Enable spell check when writing commit logs
autocmd filetype svn,*commit* setlocal spell

" Share the clipbard with OS X's clipboard
set clipboard=unnamed

" Hide buffers when not displayed
set hidden

" Do not auto-comment when pushing o/O
autocmd FileType * setlocal formatoptions-=o

" Folding settings
set foldmethod=manual
set foldnestmax=3
set nofoldenable

" Set window splits to appear below or to the right
set splitbelow
set splitright

" Set default tag locations
:set tags=.git/tags
