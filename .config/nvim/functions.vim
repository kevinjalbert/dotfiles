function OpenGitCommit()
  normal! g0
  execute ":Gedit ".expand('<cword>')
  normal! <CR>
endfunction
autocmd FileType gitevolution nnoremap <buffer> <CR> :call OpenGitCommit()<CR>
function GitEvolution() range
    " Collect output from git command
    let output = system("git log -L". a:firstline . "," . a:lastline . ":" . bufname("%")." "."--no-patch --pretty=format:'%h %ad%d %s [%cn]' --decorate --date=relative --no-patch")

    " Set up new empty split
    split __GitEvolution__
    normal! ggdG
    setlocal filetype=gitevolution
    setlocal buftype=nofile

    " Add output and move to top of buffer
    call append(0, split(output, '\v\n'))
    normal! gg
endfunction
vnoremap ge :call GitEvolution()<CR>

" Visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" Jump to last cursor position when opening a file, except on commits
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

