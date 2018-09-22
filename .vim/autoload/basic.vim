" basic.vim
"            _                    
"           (_)                   
"     __   ___ _ __ ___  _ __ ___ 
"     \ \ / | | '_ ` _ \| '__/ __|
"      \ V /| | | | | | | | | (__ 
"     (_\_/ |_|_| |_| |_|_|  \___|
"                                 
" its vim basic config.
" # buffer is active.

" スペルチェック
set spell
set spelllang=en,cjk 

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %


" 編集箇所のカーソルを記憶
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

" バックスペースを有効化
set backspace=indent,eol,start

" スクロールの余白を確保する
set scrolloff=4

" インデントはスマートインデント
set smartindent

" 折り返し時に表示行単位での移動できるようにする
set whichwrap=b,s,h,l,<,>,[,],~

" 括弧入力時の対応する括弧を表示
set showmatch matchtime=1

" タブ幅を4に設定
set tabstop=4
set shiftwidth=4

" syntax on
syntax on

" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore

set fenc=utf-8

set nobackup
set nowritebackup
set noswapfile
set autoread
set hidden
" ------------------------------------------------------------------------------
" buffer
" ------------------------------------------------------------------------------
nnoremap < :bp<CR>|

set switchbuf=useopen			" 新しく開く代わりに既存バッファを開く


set showcmd
set number

set virtualedit=block

" Windowsでもパスの区切り文字を/にする
set shellslash

" インサートモードから抜けると自動的にIMEをオフにする
set iminsert=2

"ヤンクした文字列をクリップボードと連携させる（+clipboard前提）
set clipboard&
set clipboard=unnamed,unnamedplus

" ------------------------------------------------------------------------------
" window
" ------------------------------------------------------------------------------
set splitbelow				" ウィンドウ分割を(上でなく)下側に変更
set splitright				" ウィンドウ分割を(左でなく)右側に変更
