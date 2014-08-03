" Load Bundles
set rtp+=~/.vim/bundle/vundle.vim/
call vundle#rc()

" Make sure we are using Vundle
Bundle 'gmarik/Vundle.vim'

" Allows alteration to color schemes without modifying the actual schemes
Bundle 'vim-scripts/AfterColors.vim'

" Graphical undo tree
Bundle 'sjl/gundo.vim'

" Allows quick fuzzy searching within Vim
Bundle 'kien/ctrlp.vim'

" Adds the ability to work with surroundings
Bundle 'tpope/vim-surround'

" Adds 'end' where appropriate while coding (ruby's end if/function, etc...)
Bundle 'tpope/vim-endwise'

" Heuistically set buffer options
Bundle 'vim-scripts/yaifa.vim'

" Allows the repeat of a plugin map (using '.')
Bundle 'tpope/vim-repeat'

" Displays an overview of the code's structure
Bundle 'majutsushi/tagbar'

" Provides automatic closing of quotes, parenthesis, brackets, etc...
Bundle 'Raimondi/delimitMate'

" Provides syntax checking for certain file types
Bundle 'scrooloose/syntastic'

" Display buffers in the command line, works nicely with powerline
Bundle 'buftabs'

" Provides a directory tree explorer
Bundle 'scrooloose/nerdtree'

" Provides a better experience with NERDtree
Bundle "jistr/vim-nerdtree-tabs"

" Provides many commenting operations and styles
Bundle 'scrooloose/nerdcommenter'

" Augments % matching
Bundle 'vim-scripts/matchit.zip'

" Shows the current index of the search term
Bundle 'vim-scripts/IndexedSearch'

" Augments the yank/pasting functionality
Bundle 'vim-scripts/YankRing.vim'

" Provides a set of snippets that can be used quickly
Bundle 'msanders/snipmate.vim'

" Provides syntax formating for markdown files
Bundle 'plasticboy/vim-markdown'

" Provides better Ruby support
Bundle 'vim-ruby/vim-ruby'

" Provides better Rails support
Bundle 'tpope/vim-rails'

" Provides better Ruby/Rake support
Bundle 'tpope/vim-rake'

" Shows the git diff in the gutter
Bundle 'mhinz/vim-signify'

" Provides a better status line
Bundle 'Lokaltog/powerline'

" A code-completion engine for Vim
Bundle 'Valloric/YouCompleteMe'

" Kill buffers instead of windows
Bundle 'bufkill.vim'

" Ability to use ack (ag)
Bundle 'mileszs/ack.vim'

" Allow Ctags to run when saving
Bundle 'vim-scripts/AutoTag'

" A Git wrapper to allow for the usage of Git commands
Bundle 'tpope/vim-fugitive'

" Provides a visual git interface
Bundle 'gregsexton/gitv'

" Syntax support for RABL files, and treat them like ruby files
Bundle 'yaymukund/vim-rabl'

" Add ability to make table alignments
Bundle 'godlygeek/tabular'
