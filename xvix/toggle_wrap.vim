
function! ToggleWrap()
  if &wrap
    echo "wrap: off"
    setlocal nowrap
    " set virtualedit=all
    " silent! nunmap <buffer> <Up>
    " silent! nunmap <buffer> <Down>
    " silent! nunmap <buffer> <Home>
    " silent! nunmap <buffer> <End>
    " silent! iunmap <buffer> <Up>
    " silent! iunmap <buffer> <Down>
    " silent! iunmap <buffer> <Home>
    " silent! iunmap <buffer> <End>
    silent! iunmap <buffer> k
    silent! iunmap <buffer> j
    silent! iunmap <buffer> 0
    silent! iunmap <buffer> $
  else
    echo "wrap: on"
    setlocal wrap linebreak nolist
    " set virtualedit=
    setlocal display+=lastline
    " noremap  <buffer> <silent> <Up>   gk
    " noremap  <buffer> <silent> <Down> gj
    " noremap  <buffer> <silent> <Home> g<Home>
    " noremap  <buffer> <silent> <End>  g<End>
    " inoremap <buffer> <silent> <Up>   <C-o>gk
    " inoremap <buffer> <silent> <Down> <C-o>gj
    " inoremap <buffer> <silent> <Home> <C-o>g<Home>
    " inoremap <buffer> <silent> <End>  <C-o>g<End>
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
  endif
endfunction

