
"            _                    
"           (_)                   
"     __   ___ _ __ ___  _ __ ___ 
"     \ \ / | | '_ ` _ \| '__/ __|
"      \ V /| | | | | | | | | (__ 
"     (_\_/ |_|_| |_| |_|_|  \___|
"                                 


" if has('vim_starting')
" 	set nocompatible
" endif


call plug#begin(expand('~/.vim/plugged'))
  Plug 'scrooloose/nerdtree'
  Plug 'jistr/vim-nerdtree-tabs'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'davidhalter/jedi-vim'
  Plug 'tpope/vim-commentary'
  Plug 'reireias/vim-cheatsheet'
  Plug 'thinca/vim-splash'
  Plug 'Shougo/vimproc.vim'
  Plug 'yuratomo/w3m.vim'
  Plug 'w0rp/ale'
if v:version >= 703
  Plug 'Shougo/vimshell.vim'
endif


 

"*********Vim-plugs plugin END ******************
call plug#end()



"------------------------------Plugin config*****
set t_Co=256
"------------------------------------------------

let g:WebDevIconsUnicodeDecorateFolderNodes = 1

let g:cheatseet#cheat_file = '~/.cheatsheet.md'


" NerdTree config *******************************
"キーバインド
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" 他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
 
" NerdTree config end ***************************


" Airline config --------------------------------
let g:airline_theme = 'papercolor'
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
\ 'n'  : 'Normal',
\ 'i'  : 'Insert',
\ 'R'  : 'Replace',
\ 'c'  : 'Command',
\ 'v'  : 'Visual',
\ 'V'  : 'V-Line',
\ '⌃V' : 'V-Block',
\}

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_theme = "distinguished"





"------------------------------------------------------------------
"" " Powerline系フォントを利用する
""let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#enabled = 1
"let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])

""let g:airline#extensions#tabline#buffer_idx_mode = 1
"let g:airline#extensions#whitespace#mixed_indent_algo = 1
"let g:airline_theme = 'tomorrow'
""let g:airline_skip_empty_sections = 1

"if !exists('g:airline_symbols')
"    	let g:airline_symbols = {}
"endif

""右側に使用されるセパレータ
"let g:airline_symbols.crypt = '🔒'		"暗号化されたファイル
"let g:airline_symbols.linenr = '¶'			"行
"let g:airline_symbols.maxlinenr = '㏑'		"最大行
"let g:airline_symbols.branch = '⭠'		"gitブランチ
"let g:airline_symbols.paste = 'ρ'			"ペーストモード
"let g:airline_symbols.spell = 'Ꞩ'			"スペルチェック
"let g:airline_symbols.notexists = '∄'		"gitで管理されていない場合


""airline config END------------------------------ 



"" ALE config -------------------------------------
"" エラー行に表示するマーク
"let g:ale_sign_error = '⨉'
"let g:ale_sign_warning = '⚠'
"" エラー行にカーソルをあわせた際に表示されるメッセージフォーマット
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"" エラー表示の列を常時表示
"let g:ale_sign_column_always = 1

"" ファイルを開いたときにlint実行
"let g:ale_lint_on_enter = 1
"" ファイルを保存したときにlint実行
"let g:ale_lint_on_save = 1
"" 編集中のlintはしない
"let g:ale_lint_on_text_changed = 'never'

"" lint結果をロケーションリストとQuickFixには表示しない
"" 出てると結構うざいしQuickFixを書き換えられるのは困る
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 0
"let g:ale_open_list = 0
"let g:ale_keep_list_window_open = 0

"" 有効にするlinter
"let g:ale_linters = {
"\   'python': ['flake8'],
"\}

"" ALE用プレフィックス
"nmap [ale] <Nop>
"map <C-k> [ale]
"" エラー行にジャンプ
"nmap <silent> [ale]<C-P> <Plug>(ale_previous)

"左側のシンボルカラムを常時表示
let g:ale_sign_column_always = 1

""------------------------------------------------



set fenc=utf-8

set nobackup

set nowritebackup

set noswapfile

set autoread

set hidden

set showcmd

set number

set virtualedit=block

"ヤンクした文字列をクリップボードと連携させる（+clipboard前提）
set clipboard&
set clipboard=unnamed

"Window間の移動を快適にする
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

"textが折り返されないように
syntax on

" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore

" インデントはスマートインデント
set smartindent

" 括弧入力時の対応する括弧を表示
set showmatch matchtime=1

" ステータスラインを常に表示

" 折り返し時に表示行単位での移動できるようにする
set whichwrap=b,s,h,l,<,>,[,],~

"スクロールの余裕を確保する
set scrolloff=4

"jjで挿入モードを抜ける
inoremap jj <Esc>

" ---------------検索系

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

"Yを行末までのヤンクにする
nnoremap Y y$

"カラースキーム
syntax on


" ヤンクでクリップボードにコピー
set clipboard=unnamed,autoselect

"文脈によって解釈が異なる全角文字の幅を、2に固定する
set ambiwidth=double

"set title
set title

set noshowmode

"" Tabs. May be overriten by autocmd rules
set tabstop=2
set softtabstop=0
set shiftwidth=2
set expandtab

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

set spell
set spelllang=en,cjk "日本語を除外


" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" docstringは表示しない
autocmd FileType python setlocal completeopt-=preview


" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
  endfunction

" Set tabline.
function! s:my_tabline()  "{{{
let s = ''
for i in range(1, tabpagenr('$'))
let bufnrs = tabpagebuflist(i)
let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
let no = i  " display 0-origin tabpagenr.
let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
let title = fnamemodify(bufname(bufnr), ':t')
let title = '[' . title . ']'
let s .= '%'.i.'T'
let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
let s .= no . ':' . title
let s .= mod
let s .= '%#TabLineFill# '
endfor
let s .= '%#TabLineFill#%T%=%#TabLine#'
return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
  endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

hi clear SpellBad
hi SpellBad cterm=underline

set laststatus=2
