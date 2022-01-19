" Map insert mode's esc to jk
inoremap jk <esc>

" Make j and k work on wrapped lines
:map j gj
:map k gk

" Write file as sudo
cmap w!! w !sudo tee % >/dev/null

" Manage vertical and horizontal splits
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" Avoid shift mistakes when saving/quitting
command! W w
command! WQ wq
command! Wq wq
command! Q q

" Allow misspelling of :wq
cabbrev ew :wq
cabbrev qw :wq

" A better way to move between windows
nnoremap <silent> J <C-W>j
nnoremap <silent> K <C-W>k
nnoremap <silent> H <C-W>h
nnoremap <silent> L <C-W>l

" Make Y consistent with C and D (Yank till end of line)
nmap Y y$

" Toggle NERD Tree
nnoremap <f2> :NERDTreeTabsToggle<cr>

" Easy way to surround a word using surround.vim
map sw ysiw

" Open selection on GitHub
vnoremap gho :GBrowse<CR>
