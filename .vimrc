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


" mouseを有効か
set mouse=a
set ttymouse=xterm2

" Terminal接続を高速化
set ttyfast

" スペルチェック
set spell
set spelllang=en,cjk 

syntax on
colorscheme molokai

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

" タブ幅を4に設定, スペースに
" set expandtab
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
" プラギン固有のkeymapは全て.vim/rc/*.rc.vim に切り離し済み
nnoremap <Space>rr :source ~/.vimrc<CR>

" 保存
nnoremap <Space>w :w<CR>
" とにかく終了
nnoremap <Space>Q :qa!<CR>

" emacsっぽい動き
nnoremap <C-e> $
nnoremap <C-a> 0
nnoremap <C-f> W
nnoremap <C-b> B
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0
inoremap <C-f> <C-o>W
inoremap <C-b> <C-o>B


" すばやく新規ファイルを作る
nnoremap <Space>e :edit 

" Chromeで選択したものを貼り付け
nnoremap <Space>p :r! osascript -e 'tell application "Google Chrome" to get copy selection of active tab of window 1' ; pbpaste<CR>

" terminal召喚
nnoremap <Space>t :vertical terminal ++cols=70<CR>


nnoremap <Space>sv :split<CR>

" ------------------------------------------------------------------------------
" buffer
" ------------------------------------------------------------------------------
" 新しく開く代わりに既存バッファを開く
set switchbuf=useopen

set noswapfile

" 保存されていないFileがあっても構わず別のFileを開く
set hidden

" 外部で変更されたら読み直す
set autoread
au CursorHold * checktime

" swich buffer
nnoremap <C-w>n :bnext<CR>
nnoremap <C-w>p :bprev<CR>
" ------------------------------------------------------------------------------

" Windowsでもパスの区切り文字を/にする
set shellslash

"ヤンクした文字列をクリップボードと連携させる（+clipboard前提）
set clipboard&
set clipboard=unnamed,unnamedplus

" ------------------------------------------------------------------------------
" tmux keymaps
" ------------------------------------------------------------------------------
nnoremap <Space>rt :call TmuxPaneRepeat()<CR>

nnoremap <Space>rc :call TmuxPaneClear()<CR>

" ------------------------------------------------------------------------------
" tmux functions
" ------------------------------------------------------------------------------
function TmuxPaneRepeat()
  write
  silent execute ':!tmux send-keys -t $(tmux display-message "\#S"):1.2 c-c c-p c-j'
  redraw!
endfunction

function TmuxPaneClear()
  silent execute ':!tmux send-keys -t' '$(tmux display-message "\#S"):1.2' 'c-c' 'c-j' 'c-l'
  redraw!
endfunction
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'
nnoremap ]g :GitGutterNextHunk<CR>
nnoremap [g :GitGutterPrevHunk<CR>
augroup VimDiff
  autocmd!
  autocmd VimEnter,FilterWritePre * if &diff | GitGutterDisable | endif
augroup END
" ------------------------------------------------------------------------------
" CursorLine
" ------------------------------------------------------------------------------
" 初期状態はcursorlineを表示しない
" 以下の一行は必ずcolorschemeの設定後に追加すること
highlight cursorline ctermbg=236 guibg=#293739
" 'cursorline' を必要な時にだけ有効にする
" http://d.hatena.ne.jp/thinca/20090530/1243615055
" を少し改造、number の highlight は常に有効にする
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  setlocal cursorline
  setlocal cursorcolumn

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
	  setlocal cursorcolumn
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
	  setlocal nocursorcolumn
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
		  setlocal nocursorcolumn
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
	  setlocal cursorcolumn
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END
" ------------------------------------------------------------------------------
" window
" ------------------------------------------------------------------------------
set splitbelow				" ウィンドウ分割を(上でなく)下側に変更
set splitright				" ウィンドウ分割を(左でなく)右側に変更


" jj esc
inoremap jj <Esc>
inoremap ッｊ <Esc>
inoremap っｊ <Esc>

"Yを行末までのヤンクにする
nnoremap Y y$

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" 現在行を中心に添えたままスクロール(もっといい方法アリそう)
nnoremap <C-j> jzz
nnoremap <C-k> kzz
nnoremap <C-l> lzz
nnoremap <C-h> hzz

" 折り返し時に表示行単位での移動できるようにする
set whichwrap=b,s,h,l,<,>,[,],~


" 
" set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" highlight Normal ctermbg=none

set list           " 不可視文字を表示
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮ " 不可視文字の表示記号指定

" ステータスライン周り
set laststatus=2
set showcmd				" コマンドをステータスラインに表示
set noshowmode

set wrap				" 文字を折り返す

" ALEの左側のLintからむを常時標示
let g:ale_sign_column_always = 1


" スペルミスの際にアンダーラインを引くように
highlight clear SpellBad
highlight SpellBad cterm=underline

" タイトルを表示する
set title


" ----------------------------------------------------
" functions
" ----------------------------------------------------
"" txt
augroup vimrc-wrapping
    autocmd!
    autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END
if !exists('*s:setupWrapping')
    function s:setupWrapping()
        set wrap
        set wm=2
        set textwidth=79
    endfunction
endif

"" make/cmake
augroup vimrc-make-cmake
    autocmd!
    autocmd FileType make setlocal noexpandtab
    autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

"" python
augroup vimrc-python
    autocmd!
    autocmd FileType python setlocal
                \ formatoptions+=croq softtabstop=4
                \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

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
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>


" font
set guifont=Cica:h16
set printfont=Cica:h12
set ambiwidth=double

