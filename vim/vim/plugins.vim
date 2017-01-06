call plug#begin()

" Allows alteration to color schemes without modifying the actual schemes
Plug 'vim-scripts/AfterColors.vim'

" Graphical undo tree
Plug 'sjl/gundo.vim'

" Open files at a specific line (i.e., name:10)
Plug 'bogado/file-line'

" Allows quick fuzzy searching within Vim
Plug 'ctrlpvim/ctrlp.vim'

" Adds the ability to work with surroundings
Plug 'tpope/vim-surround'

" Adds handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Adds 'end' where appropriate while coding (ruby's end if/function, etc...)
Plug 'tpope/vim-endwise'

" Heuistically set buffer options
Plug 'vim-scripts/yaifa.vim'

" Allows the repeat of a plugin map (using '.')
Plug 'tpope/vim-repeat'

" Displays an overview of the code's structure
Plug 'majutsushi/tagbar'

" Provides automatic closing of quotes, parenthesis, brackets, etc...
Plug 'Raimondi/delimitMate'

" Provides syntax checking for certain file types
Plug 'benekastah/neomake'

" Display buffers in the command line
Plug 'buftabs'

" Provides a directory tree explorer
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeTabsToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeTabsToggle', 'NERDTreeFind'] }
Plug 'jistr/vim-nerdtree-tabs', { 'on': ['NERDTreeTabsToggle', 'NERDTreeFind'] }

" Provides many commenting operations and styles
Plug 'scrooloose/nerdcommenter'

" Augments % matching
Plug 'vim-scripts/matchit.zip'

" Provides a set of snippets that can be used quickly
Plug 'msanders/snipmate.vim'

" A solid language pack for Vim
Plug 'sheerun/vim-polyglot'

" Provides better Ruby support
Plug 'vim-ruby/vim-ruby'

" Provides better Rails support
Plug 'tpope/vim-rails'

" Provides better Ruby/Rake support
Plug 'tpope/vim-rake'

" Shows the git diff in the gutter
Plug 'mhinz/vim-signify'

" Provides a better status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" A code-completion engine for Vim
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" Highlight ending tags
Plug 'Valloric/MatchTagAlways'

" Kill buffers instead of windows
Plug 'bufkill.vim'

" Ability to use ack (ag)
Plug 'mileszs/ack.vim'

" Allow Ctags to run when saving
Plug 'vim-scripts/AutoTag'

" A Git wrapper to allow for the usage of Git commands
Plug 'tpope/vim-fugitive'

" Vim start screen
Plug 'mhinz/vim-startify'

" Add feedback for substitution
Plug 'osyo-manga/vim-over'

" Add ability use GitHub Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" Be able to use editorconfig files
Plug 'editorconfig/editorconfig-vim'

" Able to visually increase a sequence of number
Plug 'triglav/vim-visual-increment'

" Intelligently toggling line numbers
Plug 'myusuf3/numbers.vim'

" Add additional vim object targets
Plug 'wellle/targets.vim'

" Add additional text objects
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'

" All around better searching
Plug 'Lokaltog/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'osyo-manga/vim-anzu'

" Use icons where possible
Plug 'ryanoasis/vim-devicons'

" Add WakaTime tracking
Plug 'wakatime/vim-wakatime'

call plug#end()
