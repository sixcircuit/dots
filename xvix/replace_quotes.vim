
function ReplaceQuotes()
   " Save cursor position
   let l:save = winsaveview()
   " replace curly quotes
   %s/[“”]/"/ge
   %s/[’]/'/ge
   " Move cursor to original position
   call winrestview(l:save)
   echo "Stripped trailing whitespace"
endfunction

