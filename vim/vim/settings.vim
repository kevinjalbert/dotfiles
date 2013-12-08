" Strip whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Automatically rebalance windows when resizing vim
autocmd VimResized * :wincmd =

" Storage for :cmdline history
set history=1000

" Shows incomplete commands in statusline
set showcmd

" Shows current mode in statusline
set showmode

" Undo settings
silent !mkdir ~/.vim/undofiles > /dev/null 2>&1
set undodir=~/.vim/undofiles
set undofile

" Turn backup off
set nobackup
set nowb
set noswapfile

" Search settings
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan

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
