" http://learnvimscriptthehardway.stevelosh.com/chapters/52.html
" Needed to put RVM script in ~/.zshenv for Vim to use correct rubygem set
function GitEvolution() range
    " Collect output
    let output = system("git_evolution" . " " . "-r" . " " . a:firstline . ":" . a:lastline . " " . bufname("%"))

    " Open a new split and set it up.
    split __GitEvolution__
    normal! ggdG
    setlocal filetype=gitevolution
    setlocal buftype=nofile

    " Insert the output.
    call append(0, split(output, '\v\n'))
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

" Strip whitespace on save
" (http://rails-bestpractices.com/posts/60-remove-trailing-whitespace)
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
" Delete fugitive buffers when we leave them
" Add a mapping on .. to view parent tree
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost fugitive://*
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" Integrate incsearch and easymotion
" https://github.com/Lokaltog/vim-easymotion/issues/146#issuecomment-75443473
" Can use / for 'normal searching', at anytime its possible to use alt + space
" to pass search over to easymotion.
augroup incsearch-easymotion
  autocmd!
  autocmd User IncSearchEnter autocmd! incsearch-easymotion-impl
augroup END
augroup incsearch-easymotion-impl
  autocmd!
augroup END
function! IncsearchEasyMotion() abort
  autocmd incsearch-easymotion-impl User IncSearchExecute :silent! call EasyMotion#Search(0, 2, 0)
  return "\<CR>"
endfunction
let g:incsearch_cli_key_mappings = {
\   "\<M-Space>": {
\       'key': 'IncsearchEasyMotion()',
\       'noremap': 1,
\       'expr': 1
\   }
\ }
