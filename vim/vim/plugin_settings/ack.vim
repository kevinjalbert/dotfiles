" Use ag instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" Use ag instead of grep
set grepprg=ag\ --nogroup\ --nocolor

" Use ag in ctrlp
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
