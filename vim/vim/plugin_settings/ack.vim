" Use ag instead of ack
let g:ackprg = 'ag --ignore-case --max-count 1000000 --nogroup --nocolor --column'

" Use ag instead of grep
set grepprg=ag\ --nogroup\ --nocolor

" Use ag in ctrlp
let g:ctrlp_user_command = 'ag %s -l --hidden --ignore-case --max-count 1000000 --nogroup --nocolor --column -g ""'
