" Load Plugins
let &rtp = &rtp . ',' . g:editor_root . '/bundle/Vundle.vim/'
call vundle#rc(g:editor_root . '/bundle')

" Make sure we are using Vundle
Plugin 'gmarik/Vundle.vim'

" Allows alteration to color schemes without modifying the actual schemes
Plugin 'vim-scripts/AfterColors.vim'

" Graphical undo tree
Plugin 'sjl/gundo.vim'

" Allows quick fuzzy searching within Vim
Plugin 'kien/ctrlp.vim'

" Adds the ability to work with surroundings
Plugin 'tpope/vim-surround'

" Adds 'end' where appropriate while coding (ruby's end if/function, etc...)
Plugin 'tpope/vim-endwise'

" Heuistically set buffer options
Plugin 'vim-scripts/yaifa.vim'

" Allows the repeat of a plugin map (using '.')
Plugin 'tpope/vim-repeat'

" Displays an overview of the code's structure
Plugin 'majutsushi/tagbar'

" Provides automatic closing of quotes, parenthesis, brackets, etc...
Plugin 'Raimondi/delimitMate'

" Provides syntax checking for certain file types
if has('nvim')
  Plugin 'benekastah/neomake'
else
  Plugin 'scrooloose/syntastic'
endif

" Display buffers in the command line
Plugin 'buftabs'

" Provides a directory tree explorer
Plugin 'scrooloose/nerdtree'

" Provides a better experience with NERDtree
Plugin 'jistr/vim-nerdtree-tabs'

" Provides many commenting operations and styles
Plugin 'scrooloose/nerdcommenter'

" Augments % matching
Plugin 'vim-scripts/matchit.zip'

" Augments the yank/pasting functionality
" TODO: Not using this until this is fixed in NeoVim (slow with 'x' delete)
" Plugin 'vim-scripts/YankRing.vim'

" Provides a set of snippets that can be used quickly
Plugin 'msanders/snipmate.vim'

" Provides syntax formating for markdown files
Plugin 'plasticboy/vim-markdown'

" Provides syntax formating for javascript files (ES6)
Plugin 'othree/yajs.vim'

" Provides better Ruby support
Plugin 'vim-ruby/vim-ruby'

" Provides better Rails support
Plugin 'tpope/vim-rails'

" Provides better Ruby/Rake support
Plugin 'tpope/vim-rake'

" Shows the git diff in the gutter
Plugin 'mhinz/vim-signify'

" Provides a better status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" A code-completion engine for Vim
Plugin 'Valloric/YouCompleteMe'

" Kill buffers instead of windows
Plugin 'bufkill.vim'

" Ability to use ack (ag)
Plugin 'mileszs/ack.vim'

" Allow Ctags to run when saving
Plugin 'vim-scripts/AutoTag'

" A Git wrapper to allow for the usage of Git commands
Plugin 'tpope/vim-fugitive'

" Provides a visual git interface
Plugin 'gregsexton/gitv'

" Syntax support for RABL files, and treat them like ruby files
Plugin 'yaymukund/vim-rabl'

" Vim start screen
Plugin 'mhinz/vim-startify'

" Add feedback for substitution
Plugin 'osyo-manga/vim-over'

" Add ability use GitHub Gist
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

" Ability to have a scratch notepad
Plugin 'mtth/scratch.vim'

" Able to visually increase a sequence of number
Plugin 'triglav/vim-visual-increment'

" Add additional vim object targets
Plugin 'wellle/targets.vim'

" Add additional text objects
Plugin 'kana/vim-textobj-entire'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-line'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'

" All around better searching
Plugin 'Lokaltog/vim-easymotion'
Plugin 'haya14busa/incsearch.vim'
Plugin 'osyo-manga/vim-anzu'
