" Airline config ===============================
let g:airline_theme = 'papercolor'
let g:airline_powerline_fonts = 1
let g:ale_sign_column_always = 1
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
" Airline config ===============================


