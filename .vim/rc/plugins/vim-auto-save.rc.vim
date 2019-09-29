let g:auto_save_silent = 1
if expand("%:p") =~ 'COMMIT_EDITMSG'
  let g:auto_save = 0
else
  let g:auto_save = 1
endif
