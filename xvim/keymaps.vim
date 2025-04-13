" https://www.johnhawthorn.com/2012/09/vi-escape-delays/
" one part of fixing slow / missing escapes in nvim
set ttimeoutlen=50

" don't timeout keymap sequences. because we shouldn't rely on the timeout
set notimeout
" set ttimeoutlen=10000

" core remaps

" one less key for command mode
nnoremap ; :
nnoremap : ;
"vnoremap ; :
"vnoremap : ;


noremap M %

" add lines easily with + and -
nnoremap + myO<esc>`y

nmap <leader>mb ysiW)

" move line to top middle. (on a big screen)
noremap zz zz10<c-e>

nnoremap <silent> <leader>fq :call FixQuotes()<CR>
nnoremap <silent> <leader>fw :call FixTrailingWhitespace()<CR>

noremap <Leader>z :call ToggleWrap()<CR>
noremap <Leader>tw :call ToggleWrap()<CR>
nmap <Leader>tp :ToggleProse<CR>
" nmap <silent> <Leader>tt :ToggleTypewriter<CR>

nmap <leader>c gcc
vmap <leader>c gc
" map <leader>n :cnext<cr>


" move things to the bottom and come back up think: 'done'
nnoremap <leader>d dapGpGmd<C-o><C-o>
vnoremap <leader>d dGo<esc>GpGmd<C-o><C-o>


" Remove trailing whitespace

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
nnoremap <leader>= ggvG=``

"let g:mustache_abbreviations = 1

" nnoremap <leader>3 :call ChangeSoftTabs(input("from: "), input("to: "))<CR>
nnoremap <leader>43 :call ChangeSoftTabs(4, 3)<CR>
nnoremap <leader>34 :call ChangeSoftTabs(3, 4)<CR>

