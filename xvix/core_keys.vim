
" map leader to space
let mapleader = " "

" use standard regexes, not vim regexes
nnoremap / /\v
vnoremap / /\v

" one less key for command mode
nnoremap ; :
vnoremap ; :

" ' now goes to the mark line and column, instead of just the line
nnoremap ' `
nnoremap ` '

" scroll the viewport faster with ctrl-y and ctrl-e
nnoremap <C-j> 5<C-e>
nnoremap <C-k> 5<C-y>

noremap M %
