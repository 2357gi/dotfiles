" show dot file
let NERDTreeShowHidden=1
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in")|NEADTree|endif

nmap <leader>e :NERDTreeToggle<CR>

