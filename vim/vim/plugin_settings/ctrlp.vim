let g:ctrlp_max_files = 1000000
let g:ctrlp_match_window = 'order:ttb,max:15'

" Search .* files/folders
let g:ctrlp_show_hidden = 1

" Custom file/folder ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|class)$',
  \ }
