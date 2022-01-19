let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_section_b = ''
let g:airline_section_x = ''
let g:airline_section_y = '%y %LL'
let g:airline_section_z = '%4lL %3cC'
let g:airline#extensions#virtualenv#enabled = 0

" lsp-status specifics
function! LspStatus() abort
  let status = luaeval('require("lsp-status").status()')
  return trim(status)
endfunction
call airline#parts#define_function('lsp_status', 'LspStatus')
call airline#parts#define_condition('lsp_status', 'luaeval("#vim.lsp.buf_get_clients() > 0")')
let g:airline#extensions#nvimlsp#enabled = 0
let g:airline_section_warning = airline#section#create_right(['lsp_status'])
