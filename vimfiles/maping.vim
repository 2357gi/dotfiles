" its
"            _                    
"           (_)                   
"     __   ___ _ __ ___  _ __ ___ 
"     \ \ / | | '_ ` _ \| '__/ __|
"      \ V /| | | | | | | | | (__ 
"     (_\_/ |_|_| |_| |_|_|  \___|

" jj esc
inoremap jj <Esc>
inoremap ッｊ <Esc>
inoremap っｊ<Esc>

"Yを行末までのヤンクにする
nnoremap Y y$

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

"Window間の移動を快適にする
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" 折り返し時に表示行単位での移動できるようにする
set whichwrap=b,s,h,l,<,>,[,],~




