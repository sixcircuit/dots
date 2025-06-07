
function FixTrailingWhitespace() abort
   " Save cursor position
   let l:save = winsaveview()
   %s/\s\+$//e
   " Move cursor to original position
   call winrestview(l:save)
   echo "removed trailing whitespace"
endfunction

function FixQuotes()
   " Save cursor position
   let l:save = winsaveview()
   %s/[“”]/"/ge
   %s/[‘’]/'/ge
   " Move cursor to original position
   call winrestview(l:save)
   echo "replaced quotes"
endfunction

function FixChars()
   " Save cursor position
   let l:save = winsaveview()
   %s/[“”]/"/ge
   %s/[‘’]/'/ge
   %s/[—]/-/ge
   %s/[–]/-/ge
   " Move cursor to original position
   call winrestview(l:save)
   echo "replaced fancy chars"
endfunction

function FixTabs3()
   " Save cursor position
   let l:save = winsaveview()
   %s/[\t]/   /ge
   " Move cursor to original position
   call winrestview(l:save)
   echo "replaced tabs with 3 spaces"
endfunction

function FixTabs2()
   " Save cursor position
   let l:save = winsaveview()
   %s/[\t]/  /ge
   " Move cursor to original position
   call winrestview(l:save)
   echo "replaced tabs with 2 spaces"
endfunction

command! FixTrailingWhitespace call FixTrailingWhitespace()
command! FixChars call FixChars()
command! FixQuotes call FixQuotes()
command! FixTabs call FixTabs3()
command! FixTabs2 call FixTabs2()
command! FixTabs3 call FixTabs3()

