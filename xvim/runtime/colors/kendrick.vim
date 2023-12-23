
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" echo "colorscheme: kendrick"
" echo 'source ' . s:root . "/colors.vim"
" echo 'source ' . s:root . "/colors.lua"

exe 'source ' . s:root . "/colors.vim"
exe 'source ' . s:root . "/colors.lua"

