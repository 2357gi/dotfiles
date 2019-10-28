let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

nmap m <Plug>(easymotion-overwin-f)
nmap <leader>m <Plug>(easymotion-overwin-f2)

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map f <Plug>(easymotion-fl)
map F <Plug>(easymotion-Fl)

