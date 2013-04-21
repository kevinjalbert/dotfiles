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

" Automatically reload vimrc when it's saved
autocmd BufWritePost .vimrc doautocmd ColorScheme .vimrc

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

" Set textwidth
set textwidth=120

" Set powerline up (explict font when running with GUI)
if has("gui_running")
  set guifont=Inconsolata\ for\ Powerline:h13
endif
set antialias
set laststatus=2


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
let g:ctrlp_max_files = 10000
let g:ctrlp_custom_ignore = {
    \   'dir':  '\.git$\|\.hg$\|\.svn$',
    \   'file': '\.exe$\|\.so$\|\.dll$',
    \ }

" Optimize file searching
if has("unix")
  let g:ctrlp_user_command = {
      \   'types': {
      \     1: ['.git/', 'cd %s && git ls-files']
      \   },
      \   'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
      \ }
endif

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

" VIM-SLEUTH
" Heuistically set buffer options
" -----------
Bundle 'tpope/vim-sleuth'

" ANSIESC
" Inteprets ANSI color codes
" -------
Bundle 'vim-scripts/AnsiEsc.vim'

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

" NERDTREE
" Provides a directory tree explorer
" --------
Bundle 'scrooloose/nerdtree'
let g:NERDTreeChDirMode=2
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40
autocmd vimenter * if !argc() | NERDTree | endif  " Opens if no files

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
let g:snips_author = "Kevin Jablbert"

" CSAPPROX
" Makes color schemes work 'just work' in terminal Vim
" --------
Bundle 'godlygeek/csapprox'
if !has("gui")
  let g:CSApprox_loaded = 1
endif

" MARKDOWN
" Provides syntax formating for markdown files
" --------
Bundle 'plasticboy/vim-markdown'

" SUPERTAB
" Provides autocompleting features using tab
" --------
Bundle 'ervandew/supertab'
set completeopt=menu,longest
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLongestHighlight = 1
let g:SuperTabLongestEnhanced = 1

" VIM-RUBY
" Provides better Ruby support
" --------
Bundle 'vim-ruby/vim-ruby'

" VIM_GITGUTTER
" Shows the git diff in the gutter
" --------
Bundle 'airblade/vim-gitgutter'

" NEOCOMPLCACHE
" Provides Auto-Completion
" --------
Bundle 'Shougo/neocomplcache'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_disable_auto_complete = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" GITV
" Provides a visual git interface
" --------
Bundle 'gregsexton/gitv'

" POWERLINE
" Provides a better status line
" --------
Bundle 'Lokaltog/powerline'
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

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

" Line settings
set number
set rnu

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
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q

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

" Clear the highlighting and redraw screen
nnoremap <silent> <leader>h :nohls<CR>
inoremap <silent> <leader>h <C-O>:nohls<CR>

" Toggle NERD Tree
nnoremap <f2> :NERDTreeToggle<cr>

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

" Toggle numbering mode
function! g:ToggleNuMode()
  if(&rnu == 1)
    set nu
  else
    set rnu
  endif
endfunc
nnoremap <f9> :call g:ToggleNuMode()<cr>

" Quickfinding with CtrlP
nmap ,f :CtrlPMixed<CR>
nmap ,t :CtrlPBufTagAll<CR>
nmap ,b :CtrlPBuffer<CR>


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
