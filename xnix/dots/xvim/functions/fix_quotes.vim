
function FixQuotes()
   " Save cursor position
   let l:save = winsaveview()
   %s/[“”]/"/ge
   %s/[‘’]/'/ge
   " Move cursor to original position
   call winrestview(l:save)
   echo "replaced quotes"
endfunction

command! FixQuotes call FixQuotes()

