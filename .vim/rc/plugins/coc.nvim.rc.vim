nmap <silent> gd <Plug>(coc-definition)

    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
    " Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " Use K for show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
    if &filetype == 'vim'
    execute 'h '.expand('<cword>')
    else
    call CocAction('doHover')
    endif
    endfunction

