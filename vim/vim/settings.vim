" Automatically rebalance windows when resizing vim
autocmd VimResized * :wincmd =

" Storage for :cmdline history
set history=1000

" Shows incomplete commands in statusline
set showcmd

" Shows current mode in statusline
set showmode

" Undo settings
silent !mkdir g:vim_home . 'undofiles' > /dev/null 2>&1
execute 'set undodir=' . g:vim_home . 'undofiles'
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

if has('nvim')
  " Run neomake on file saves
  autocmd! BufWritePost * Neomake
endif

" Folding settings
set foldmethod=manual
set foldnestmax=3
set nofoldenable

" Set window splits to appear below or to the right
set splitbelow
set splitright

" Set default tag locations
:set tags=.git/tags

" Allow vim-startify to cooperate with NERDTree and CtrlP (for some reason
" placement in `plugin_settings/vim-startify.vim` wouldn't work)
autocmd User Startified setlocal buftype=
