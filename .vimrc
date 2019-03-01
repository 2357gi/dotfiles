" basic.vim
"            _                    
"           (_)                   
"     __   ___ _ __ ___  _ __ ___ 
"     \ \ / | | '_ ` _ \| '__/ __|
"      \ V /| | | | | | | | | (__ 
"     (_\_/ |_|_| |_| |_|_|  \___|
"                                 
" its vim basic config.

" Plugin
runtime! rc/dein/dein.vim

" leaderをspaceに
let mapleader = "\<Space>"



" Terminal接続を高速化
set ttyfast

" スペルチェック
set spell
set spelllang=en,cjk 

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

syntax on

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

" 括弧入力時の対応する括弧を表示
set showmatch matchtime=1

" タブ幅を4に設定
set tabstop=4
set shiftwidth=4

" 行末の1文字先までカーソルを移動できるように
set virtualedit=block

set fenc=utf-8

set nobackup


" F3で相対行表示切り替え
set number
nnoremap <F3> :<C-u>setlocal relativenumber!<CR>

" ----------------------------------------------------
" key mapping
" ----------------------------------------------------
nmap <leader>o :FZF<CR>
nmap <leader>e :NERDTreeToggle<CR>
nmap <leader>f :Buffers<CR>
nmap q: :q

" ------------------------------------------------------------------------------
" buffer
" ------------------------------------------------------------------------------
nnoremap < :bp<CR>|

set switchbuf=useopen			" 新しく開く代わりに既存バッファを開く


" 保存されていないFileがあっても構わず別のFileを開く
set hidden
" 外部で変更されたら読み直す
set autoread
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
" ------------------------------------------------------------------------------

" Windowsでもパスの区切り文字を/にする
set shellslash

"ヤンクした文字列をクリップボードと連携させる（+clipboard前提）
set clipboard&
set clipboard=unnamed,unnamedplus

" ------------------------------------------------------------------------------
" window
" ------------------------------------------------------------------------------
set splitbelow				" ウィンドウ分割を(上でなく)下側に変更
set splitright				" ウィンドウ分割を(左でなく)右側に変更


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


colorscheme molokai
" 
" set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

highlight Normal ctermbg=none

set list           " 不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮ " 不可視文字の表示記号指定

" ステータスライン周り
set laststatus=2
set showcmd				" コマンドをステータスラインに表示

set wrap				" 文字を折り返す

" ALEの左側のLintからむを常時標示
let g:ale_sign_column_always = 1

hi clear SpellBad
hi SpellBad cterm=underline

" タイトルを表示する
set title
" ----------------------------------------------------
" 検索系
" ----------------------------------------------------
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト表示
set hlsearch

" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>


" font
set guifont=Cica:h16
set printfont=Cica:h12
set ambiwidth=double

