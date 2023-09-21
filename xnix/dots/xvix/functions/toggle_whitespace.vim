
" see whitespace
"set list
"set listchars=tab:>-,eol:¬
" set listchars=tab:▸\ ,trail:·
" set listchars=tab:▸\ ,trail:·
" set showbreak=↪\ 
" set listchars=tab:▸\ ,eol:¬,nbsp:·,trail:·,extends:›,precedes:‹
set listchars=tab:▸\ ,nbsp:·,trail:·,extends:›,precedes:‹

" if you do later have the wrap be sane
set breakindent
set showbreak=\ \ 

function! ToggleWhitespace()
  if &list
    echo "whitespace: off"
    set nolist
    set showbreak=\ \ 
  else
    echo "whitespace: on"
    set list
    set showbreak=↪\ 
  endif
endfunction

command! ToggleWhitespace call ToggleWhitespace()
 

