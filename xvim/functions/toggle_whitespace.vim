
" see whitespace
"set list
"set listchars=tab:>-,eol:¬
" set listchars=tab:▸\ ,trail:·
" set listchars=tab:▸\ ,trail:·
" set showbreak=↪\ 

" let &listchars = chars_normal

" function! InsertWhitespace()
"    let chars_insert="tab:▸\ "
"    let &listchars = chars_insert
" endfunction
"
" function! NormalWhitespace()
"    let chars_normal="tab:▸\ ,nbsp:·,trail:·,extends:›,precedes:‹"
"    let &listchars = chars_normal
" endfunction
"
"
" set list
" call NormalWhitespace()
"
" autocmd InsertEnter * call InsertWhitespace()
" autocmd InsertLeave * call NormalWhitespace()


" if you do later have the wrap be sane
set breakindent
set showbreak=\ \ 

set listchars=tab:▸\ ,eol:¬,nbsp:·,trail:·,extends:›,precedes:‹

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
 

