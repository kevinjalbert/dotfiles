" Quick line comment toggle using NERDCommenter
nmap <leader>/ :call nerdcommenter#Comment(0, "invert")<cr>
vmap <leader>/ :call nerdcommenter#Comment(0, "invert")<cr>

" Switch between last buffers
nmap <leader>l :b#<CR>

" Toggle NERDTree and navigate to the current file
nmap <leader><f2> :NERDTreeFind<cr>
" Find and replace text under cursor (use vim-over)
nnoremap <leader>s :OverCommandLine<CR> %s/<C-r><C-w>/

" Better substitution using vim-over
function! VisualFindAndReplace()
    :OverCommandLine %s/
    :noh
endfunction
function! VisualFindAndReplaceWithSelection() range
    :'<,'>OverCommandLine s/
    :noh
endfunction
nnoremap <Leader>v :call VisualFindAndReplace()<CR>
xnoremap <Leader>v :call VisualFindAndReplaceWithSelection()<CR>
