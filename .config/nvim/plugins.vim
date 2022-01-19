call plug#begin()

" Theme
Plug 'morhetz/gruvbox'

" Autocomplete (with snippet support)
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'

" A Git wrapper to allow for the usage of Git commands
Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-surround'

" All around better searching
Plug 'haya14busa/incsearch.vim'
Plug 'osyo-manga/vim-anzu'

" Provides a directory tree explorer
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeTabsToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeTabsToggle', 'NERDTreeFind'] }
Plug 'jistr/vim-nerdtree-tabs', { 'on': ['NERDTreeTabsToggle', 'NERDTreeFind'] }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': ['NERDTreeTabsToggle', 'NERDTreeFind'] }

" Provides many commenting operations and styles
Plug 'scrooloose/nerdcommenter'

" Vim start screen
Plug 'mhinz/vim-startify'

" Add feedback for substitution
Plug 'osyo-manga/vim-over'

Plug 'vim-airline/vim-airline'

" Provides awesome search via telescope
" TODO: Learn and map
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'ryanoasis/vim-devicons'

call plug#end()
