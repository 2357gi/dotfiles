"
" ui.vim
"

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

set matchtime=3				" 対応括弧のハイライト表示を3秒にする
set wrap				" 文字を折り返す

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
" タブライン表示　エラー出てるのでコメントアウト
" let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
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

" タイトルを表示する
set title

"スクロールの余裕を確保する
set scrolloff=4


" 検索系

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





