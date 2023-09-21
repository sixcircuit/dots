
function! GoogleSearch()
   let searchterm = getreg("g")
   let searchterm = substitute(searchterm, "\n", " ", "g")
   let searchterm = UrlEncode(searchterm)
   let searchterm = shellescape(searchterm, 1)
   " echo "searchterm: " . searchterm
   silent! exec "!open 'https://google.com/search?q=" . searchterm . "'"
   " exec "!echo 'https://google.com/search?q=" . searchterm . "'"
   " redraw!
endfunction

