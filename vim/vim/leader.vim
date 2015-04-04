" Quick line comment toggle using NERDCommenter
nmap <leader>/ :call NERDComment(0, "invert")<cr>
vmap <leader>/ :call NERDComment(0, "invert")<cr>

" Switch between last buffers
nmap <leader>l :b#<CR>

" Toggle NERDTree and navigate to the current file
nmap <leader><f2> :NERDTreeFind<cr>

" Quickfinding with CtrlP
nmap <leader>f :CtrlPRoot<CR>
nmap <leader>t :CtrlPBufTagAll<CR>
nmap <leader>e :CtrlPBuffer<CR>

" Move to the next/prev buffer using buftabs
noremap <silent> <leader>m :bprev<CR>
noremap <silent> <leader>. :bnext<CR>

" Search the current directory with ag using ack.vim
nmap <leader>a :Ack<space>

" Find and replace text under cursor
" http://vim.wikia.com/wiki/Search_and_replace_the_word_under_the_cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>/

" Better substitution using vim-over
function! VisualFindAndReplace()
    :OverCommandLine%s/
    :noh
endfunction
function! VisualFindAndReplaceWithSelection() range
    :'<,'>OverCommandLine s/
    :noh
endfunction
nnoremap <Leader>v :call VisualFindAndReplace()<CR>
xnoremap <Leader>v :call VisualFindAndReplaceWithSelection()<CR>
