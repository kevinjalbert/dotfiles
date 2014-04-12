" Map new leader (,) and localleader (\)
let mapleader = ","
let maplocalleader = "\\"

" Quick line comment toggle using NERDCommenter
nmap <leader>/ :call NERDComment(0, "invert")<cr>
vmap <leader>/ :call NERDComment(0, "invert")<cr>

" Switch between last buffers
nmap <leader>l :b#<CR>

" Toggle NERDTree and navigate to the current file
nmap <leader><f2> :NERDTreeFind<cr>

" Quickfinding with CtrlP
nmap ,f :CtrlPRoot<CR>
nmap ,t :CtrlPBufTagAll<CR>
nmap ,e :CtrlPBuffer<CR>

" Move to the next/prev buffer using buftabs
noremap <silent> <leader>m :bprev<CR>
noremap <silent> <leader>. :bnext<CR>

" Search the current directory with ag using ack.vim
nmap <leader>a :Ack<space>
