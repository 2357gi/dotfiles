nnoremap <leader>o  :call FzfOmniFiles()<CR>
nnoremap <leader>f :Buffers<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <C-g> :Rg<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --line-number --no-heading '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'options': '--exact --reverse --delimiter : --nth 3..'}, 'right:50%:wrap'))

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GitFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

function! FzfOmniFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    :GitFiles
  endif
endfunction


command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
