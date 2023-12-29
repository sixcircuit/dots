
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" echo "colorscheme: kendrick"
" echo 'source ' . s:root . "/colors.vim"
" echo 'source ' . s:root . "/colors.lua"

set background=dark

highlight clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "kendrick"

if exists("g:no_fancy_highlighting") && g:no_fancy_highlighting == 1
   exe 'source ' . s:root . "/original.vim"
else
   exe 'source ' . s:root . "/colors.vim"
   exe 'source ' . s:root . "/colors.lua"
endif

