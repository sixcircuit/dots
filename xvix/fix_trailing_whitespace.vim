
function FixTrailingWhitespace()
   " Save cursor position
   let l:save = winsaveview()
   %s/\s\+$//e
   " Move cursor to original position
   call winrestview(l:save)
   echo "removed trailing whitespace"
endfunction

command! FixTrailingWhitespace call FixTrailingWhitespace()
