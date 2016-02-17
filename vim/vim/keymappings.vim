" Map insert mode's esc to jk
inoremap jk <esc>

" Make j and k work on wrapped lines
:map j gj
:map k gk

" Write file as sudo
cmap w!! w !sudo tee % >/dev/null

" Move selection/line up or down
nnoremap <C-j> :m+<CR>==
nnoremap <C-k> :m-2<CR>==
inoremap <C-j> <Esc>:m+<CR>==gi
inoremap <C-k> <Esc>:m-2<CR>==gi
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Manage vertical and horizontal splits
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s
noremap <C-left> :vertical resize -1<CR>
noremap <C-right> :vertical resize +1<CR>
noremap <C-up> :resize +1<CR>
noremap <C-down> :resize -1<CR>

" Avoid shift mistakes when saving/quitting
command! W w
command! WQ wq
command! Wq wq
command! Q q

" Allow misspelling of :wq
cabbrev ew :wq
cabbrev qw :wq

" Start external commands with a single bang
nnoremap ! :!

" A better way to move between windows
nnoremap <silent> J <C-W>j
nnoremap <silent> K <C-W>k
nnoremap <silent> H <C-W>h
nnoremap <silent> L <C-W>l

" Make Y consistent with C and D (Yank till end of line)
nmap Y y$

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
inoremap <f7> <C-O>za
nnoremap <f7> za
onoremap <f7> <C-C>za
vnoremap <f7> zf

" Toggle Gundo
nnoremap <f8> :GundoToggle<CR>

" Easy way to surround a word using surround.vim
map sw ysiw

" Two character seek (vim-easymotion)
map <Space>s <Plug>(easymotion-s2)

" jk motions: Line motions (vim-easymotion)
map <Space>j <Plug>(easymotion-j)
map <Space>k <Plug>(easymotion-k)

if has('nvim')
  " While in a terminal use esc to drop into normal mode
  tnoremap <esc> <c-\><c-n>
end
