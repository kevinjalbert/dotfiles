" ----------------------------------------------------------------------------
" My personal Vim configuration using Vundle for plugins
"
" Bits and pieces of this configuration are adapted from the two amazing
" vim configurations of scrooloose/vimfiles and astrails/dotvim from their
" GitHub repositories.
"
" Author: Kevin Jalbert <kevin.j.jalbert@gmail.com>
" ----------------------------------------------------------------------------

" Use Vim settings instead of vi
set nocompatible

" Set default shell to be bash
set shell=/bin/sh

" Automatically reload vimrc when it's saved
autocmd BufWritePost .vimrc nested source ~/.vimrc

" Strip whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Map new leader (,) and localleader (\)
let mapleader = ","
let maplocalleader = "\\"

" Terminal has 256 colors and utf-8 encoding
set t_Co=256
set encoding=utf-8

" Set the color scheme
set background=dark
colorscheme Tomorrow-Night

" Set textwidth and indention
set textwidth=120
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

" Speed up ESC from insert
set ttimeoutlen=50

" Set powerline up (explict font when running with GUI)
if has("gui_running")
  set guifont=Inconsolata\ for\ Powerline:h13
endif
set antialias
set laststatus=2

" Automatically rebalance windows when resizing vim
autocmd VimResized * :wincmd =


" --------------------------
" Bundles and their settings
" --------------------------


" VUNDLE
" Make sure we are using Vundle
" ------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" AFTERCOLORS
" Allows alteration to color schemes without modifying the actual schemes
" -----------
Bundle 'vim-scripts/AfterColors.vim'

" GUNDO.VIM
" Graphical undo tree
" ---------
Bundle 'sjl/gundo.vim'

" CTRLP
" Allows quick fuzzy searching within Vim
" -----------
Bundle 'kien/ctrlp.vim'
let g:ctrlp_max_files = 1000000
let g:ctrlp_match_window = 'order:ttb,max:15'

" Search .* files/folders
let g:ctrlp_show_hidden = 1

" Custom file/folder ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|class)$',
  \ }


" FUGITIVE
" A Git wrapper to allow for the usage of Git commands
" --------
Bundle 'tpope/vim-fugitive'

" VIM-SURROUND
" Adds the ability to work with surroundings
" ------------
Bundle 'tpope/vim-surround'

" ENDWISE
" Adds 'end' where appropriate while coding (ruby's end if/function, etc...)
" ------------
Bundle 'tpope/vim-endwise'

" YAIFA
" Heuistically set buffer options
" -----------
Bundle 'vim-scripts/yaifa.vim'

" REPEAT
" Allows the repeat of a plugin map (using '.')
" ----------
Bundle 'tpope/vim-repeat'

" TAGBAR
" Displays an overview of the code's structure
" -------
Bundle 'majutsushi/tagbar'
let g:tagbar_compact = 1
let g:tagbar_autoshowtag = 1

" VIM-EASYMOTION
" Provides easy vim motions
" --------------
Bundle 'Lokaltog/vim-easymotion'

" DELIMITMATE
" Provides automatic closing of quotes, parenthesis, brackets, etc...
" -----------
Bundle 'Raimondi/delimitMate'
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1

" SYNTASTIC
" Provides syntax checking for certain file types
" ---------
Bundle 'scrooloose/syntastic'
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2

" BUFTABS
" Display buffers in the command line, works nicely with powerline
" --------
Bundle 'buftabs'
noremap <silent> <leader>; :bprev<CR>
noremap <silent> <leader>' :bnext<CR>

" NERDTREE
" Provides a directory tree explorer
" --------
Bundle 'scrooloose/nerdtree'
let g:NERDTreeChDirMode=2
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40

" NERDTREE-TABS
" Provides a better experience with NERDtree
" --------
Bundle "jistr/vim-nerdtree-tabs"

" NERDCOMMENTER
" Provides many commenting operations and styles
" --------
Bundle 'scrooloose/nerdcommenter'

" MATCHIT
" Augments % matching
" -------
Bundle 'vim-scripts/matchit.zip'

" INDEXEDSEARCH
" Shows the current index of the search term
" -------------
Bundle 'vim-scripts/IndexedSearch'

" YANKRING
" Augments the yank/pasting functionality
" --------
Bundle 'vim-scripts/YankRing.vim'

" SNIPMATE
" Provides a set of snippets that can be used quickly
" --------
Bundle 'msanders/snipmate.vim'
let g:snips_author = "Kevin Jalbert"

" MARKDOWN
" Provides syntax formating for markdown files
" --------
Bundle 'plasticboy/vim-markdown'

" VIM-RUBY
" Provides better Ruby support
" --------
Bundle 'vim-ruby/vim-ruby'

" VIM_SIGNIFY
" Shows the git diff in the gutter
" --------
Bundle 'mhinz/vim-signify'
let g:signify_mapping_next_hunk = '<leader>gj'
let g:signify_mapping_prev_hunk = '<leader>gk'
let g:signify_mapping_toggle_highlight = '<leader>gh'
let g:signify_mapping_toggle = '<leader>gt'

" GITV
" Provides a visual git interface
" --------
Bundle 'gregsexton/gitv'

" POWERLINE
" Provides a better status line
" --------
Bundle 'Lokaltog/powerline'
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" YOUCOMPLETEME
" A code-completion engine for Vim
" --------
Bundle 'Valloric/YouCompleteMe'
let g:EclimCompletionMethod = 'omnifunc'

" BUFKILL
" Kill buffers instead of windows
" --------
Bundle 'bufkill.vim'

" VIM-COMMAND-W
" Kill buffers on CMD-W instead of windows for MacVim
" --------
Bundle 'nathanaelkane/vim-command-w'

" ACK
" Ability to use ack (ag)
" --------
Bundle 'mileszs/ack.vim'
let g:ackprg = 'ag --nogroup --nocolor --column'  " Use ag instead of ack
set grepprg=ag\ --nogroup\ --nocolor  " Use ag instead of grep
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'  " Use ag in CtrlP
nmap <leader>a :Ack<space>

" VIM-MULTIPLE-CURSORS
" Multiple cursor editing in Vim
" --------
Bundle 'terryma/vim-multiple-cursors'


" ----------------
" General settings
" ----------------


" Increase tty redraw speed
set ttyfast
set lazyredraw

" Turn off null characters
imap <Nul> <Space>
imap <Nul> <Nop>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>

" Reload files changed outside vim
set autoread

" Automatically detect file types
filetype plugin indent on

" Enable backspacing over everything in insert mode
set backspace=indent,eol,start

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

" This unsets the 'last search pattern' register by hitting escape.
nnoremap <ESC> :noh<CR>:<backspace>

" Line settings
set number

" Display column and cursor line
set colorcolumn=+1
set cursorline

" Wrap lines (if so only at linebreaks)
set wrap
set nolist
set linebreak
set textwidth=0
set wrapmargin=0

" List characters
set list
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
  endif
endif

" Indent settings
set tabstop=2
set autoindent

" Folding settings
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Make command line tab complete with cycling
set wildmode=full
set wildmenu
set wildignore=*.o,*.obj,*~

" Vertical and horizontal scroll off settings
set scrolloff=10
set sidescrolloff=15
set sidescroll=1

" Do not auto-comment when pushing o/O
autocmd FileType * setlocal formatoptions-=o

" Hide buffers when not displayed
set hidden

" Enable syntax highlighting
syntax on

" Enable mouse within terminal
set mouse=a
set ttymouse=xterm2

" Enable spell check when writing commit logs
autocmd filetype svn,*commit* setlocal spell

" Share the clipbard with OS X's clipboard
set clipboard=unnamed


" ---------------------
" Mappings and bindings
" ---------------------


" Map Insert mode's esc to jk
inoremap jk <esc>

" Make j and k work on wrapped lines
:map j gj
:map k gk

" Write file as sudo (Steve Losh)
cmap w!! w !sudo tee % >/dev/null

" Move selection/line up or down
nnoremap <C-j> :m+<CR>==
nnoremap <C-k> :m-2<CR>==
inoremap <C-j> <Esc>:m+<CR>==gi
inoremap <C-k> <Esc>:m-2<CR>==gi
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv

" Quick line comment toggle using NERDCommenter
nmap <leader>/ :call NERDComment(0, "invert")<cr>
vmap <leader>/ :call NERDComment(0, "invert")<cr>

" Manage vertical and horizontal splits
set splitbelow
set splitright
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s
noremap <C-left> :vertical resize -1<CR>
noremap <C-right> :vertical resize +1<CR>
noremap <C-up> :resize +1<CR>
noremap <C-down> :resize -1<CR>

" Avoid shift mistakes
command! W w
command! WQ wq
command! Wq wq
command! Q q

" Better way to move between windows
nnoremap <silent> J <C-W>j
nnoremap <silent> K <C-W>k
nnoremap <silent> H <C-W>h
nnoremap <silent> L <C-W>l

" Wrap line(s) to textwidth
noremap Q gq

" Make Y consistent with C and D (Yank till end of line)
nnoremap Y y$

" Switch between last buffers
nmap <leader>l :b#<CR>

" Toggle NERD Tree
nnoremap <f2> :NERDTreeTabsToggle<cr>

" Toggle TagList
nnoremap <f3> :TagbarToggle<cr>

" Toggle YankRing
nnoremap <f4> :YRShow<CR>

" Auto-indent file
map <f5> mzgg=G'z<CR>

" Toggle spellcheck (only within insert mode)
imap <f6> <C-o>:setlocal spell! spelllang=en_us<CR>

" Toggle code folding based on selection (select then f7 to fold)
set foldmethod=manual
inoremap <f7> <C-O>za
nnoremap <f7> za
onoremap <f7> <C-C>za
vnoremap <f7> zf

" Toggle Gundo
nnoremap <f8> :GundoToggle<CR>

" Quickfinding with CtrlP
nmap ,f :CtrlPCurWD<CR>
nmap ,t :CtrlPBufTagAll<CR>
nmap ,e :CtrlPBuffer<CR>


" ---------------------------------------
" Misc functions (from other vimrc files)
" ---------------------------------------


" Visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
"hacks from above (the url, not jesus) to delete fugitive buffers when we
"leave them - otherwise the buffer list gets poluted
"
"add a mapping on .. to view parent tree
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost fugitive://*
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" http://stackoverflow.com/a/6171215/583592
" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

" Start the find and replace command across the entire file
vmap <leader>z <Esc>:%s/<c-r>=GetVisual()<cr>/
