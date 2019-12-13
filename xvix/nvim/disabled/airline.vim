
let g:airline_theme='powerlineish'

let g:airline_inactive_collapse=1
let g:airline_detect_spell=0
let g:airline_detect_modified = 0 "if you're sticking the + in section_c you probably want to disable detection

let g:airline_theme_patch_func = 'AirlineThemePatch'

function! AirlineThemePatch(palette)
 if g:airline_theme == 'powerlineish'
   for colors in values(a:palette.inactive)
     let colors[3] = red
   endfor
 endif
endfunction

function! AirlineInit()
  call airline#parts#define_raw('modified', '%{&modified ? " •" : ""}')
  call airline#parts#define_accent('modified', 'red')
  let g:airline_section_c = airline#section#create(['%f', 'modified'])
endfunction

autocmd VimEnter * call AirlineInit()
autocmd User AirlineAfterInit call AirlineInit()



