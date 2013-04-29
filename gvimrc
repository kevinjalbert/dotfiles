" Set up CommandW for MacVim
if has('gui_macvim')
  macmenu &File.Close key=<nop>
  nmap <D-w> :CommandW<CR>
  imap <D-w> <Esc>:CommandW<CR>
endif

