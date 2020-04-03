" copy https://yaasita.github.io/2018/11/23/translate/
"

command! -nargs=0 Eiwa call Trans()
command! -nargs=0 -range HonyakuEJ <line1>,<line2>!trans -no-ansi -from en -to ja -show-original=n -show-languages=n -show-prompt-message=n -show-alternatives=n -show-translation-phonetics=n
command! -nargs=0 -range HonyakuJE <line1>,<line2>!trans -no-ansi -from ja -to en -show-original=n -show-languages=n -show-prompt-message=n -show-alternatives=n -show-translation-phonetics=n
function! Trans()
    let l:search_word = expand("<cword>")
    let l:result = system("trans -no-ansi -from en -to ja -show-original=n -show-languages=n -show-prompt-message=n -show-alternatives=n -show-translation-phonetics=n -show-original-phonetics=n -show-dictionary=n " . l:search_word)
    echo l:result
endfunction

