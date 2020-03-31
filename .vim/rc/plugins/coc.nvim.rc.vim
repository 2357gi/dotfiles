nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
    " Remap for rename current word
nnoremap <leader>rn <Plug>(coc-rename)
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


nnoremap <C-c> <Nop>
" call coc-lists outline
nnoremap <C-c>o :<C-u>CocList outline --auto-preview<CR>

" -------------------------
" copy from coc-lists doc
" https://github.com/neoclide/coc-lists
"
" grep word under cursor
command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList grep '.<q-args>

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <C-c>c :exe 'CocList --auto-preview -I --input='.expand('<cword>').' grep'<CR>

" --------------------------
