nmap <leader>o :FZF<CR>
nmap <leader>f :Buffers<CR>

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)