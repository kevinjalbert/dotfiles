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

" Set powerline up (explict font when running with GUI)
if has("gui_running")
  set guifont=Inconsolata\ for\ Powerline:h13
endif
if has("vim")
  set antialias
end
set laststatus=2

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

" Vertical and horizontal scroll off settings
set scrolloff=10
set sidescrolloff=15
set sidescroll=1
