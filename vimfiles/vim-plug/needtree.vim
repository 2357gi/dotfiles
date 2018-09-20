" ---NERDTree conf ============================
"キーバインド
nnoremap <silent><C-y> :NERDTreeToggle<CR>
" 他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

