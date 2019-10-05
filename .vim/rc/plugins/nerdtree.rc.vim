let g:NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.git/', '\~$']

"file指定なしでvimを起動した場合だけnerdtreeを開く
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" NERDTreeだけが残る場合にvimを自動的に閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

nnoremap <Space>l :NERDTreeToggle<CR>

