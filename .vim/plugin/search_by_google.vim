" based https://www.rasukarusan.com/entry/2019/03/09/011630
" カーソル下の単語をGoogleで検索する
" 範囲選択が行われていた場合、それを検索するように

" from https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
" おこ
function! GetVisualSelection() range
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    if lnum1 == 0 && lnum2 == 0 && col1 == 0 && col2 == 0
        return ''
    endif
    let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction

function! s:search_by_google(line1, line2, ...) range
    if mode() == 'n'
        let s:searchWord = expand("<cword>")
    else
        let s:searchWord = GetVisualSelection()
    endif

    let s:executeCmd = 'open https://www.google.co.jp/search\?q\="'.s:searchWord.'"'
    echo system(s:executeCmd)
    " execute 'call cursor(' . line . ',' . col . ')'

endfunction
command! -range -nargs=* SearchByGoogle call s:search_by_google(<line1>, <line2>)
nnoremap <silent> <Space>g :SearchByGoogle<CR>

