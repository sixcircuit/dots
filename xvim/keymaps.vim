" https://www.johnhawthorn.com/2012/09/vi-escape-delays/
" one part of fixing slow / missing escapes in nvim
set ttimeoutlen=50

" don't timeout keymap sequences. because we shouldn't rely on the timeout
set notimeout
" set ttimeoutlen=10000

noremap M %

" add lines easily with + and -
nnoremap + myO<esc>`y

nmap ;a gcc
vmap ;a gc
" map <leader>n :cnext<cr>

" move things to the bottom and come back up think: 'done'
nnoremap <space>d dapGpGmd<C-o><C-o>
vnoremap <space>d dGo<esc>GpGmd<C-o><C-o>

" noremap 0 ^

" use increment inside tmux or screen
" nnoremap <C-e> <C-a>

" Match Tag Always

let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ '.html.mu' : 1,
    \ '.html.hb' : 1,
    \}

" end Match Tag Always

" reformat buffer
"nnoremap <leader>= ggvG=``


