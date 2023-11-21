
" https://www.johnhawthorn.com/2012/09/vi-escape-delays/
" one part of fixing slow / missing escapes in nvim
set ttimeoutlen=50

" don't timeout keymap sequences. because we shouldn't rely on the timeout
set notimeout
" set ttimeoutlen=10000

" core remaps

" one less key for command mode
nnoremap ; :
vnoremap ; :

nnoremap : ;
vnoremap ; :


" ' now goes to the mark line and column, instead of just the line
nnoremap ' `
nnoremap ` '

" yank till the end of the line
noremap Y y$

noremap M %

" so I don't have to reach for shift. I can ctrl-| to go to col 0
" noremap <c-\> \|
" map <C-m> :Rg input("/") <bar> :cc 0<cr>
" map <C-i> :Inspect<cr>
" map <C-i> :call SynStack()<cr>
map <leader>s :w <bar> :source %<cr>

" nnoremap <C-k> <Up>
" nnoremap <C-j> <Down>

" add lines easily with + and -
nnoremap + maO<esc>`a
nnoremap - mao<esc>`a

nnoremap <leader>ye y$
nnoremap <leader>yb y^
nnoremap <leader>y0 y^

nmap <leader>mb ysiW)

" move line to top middle. (on a big screen)
noremap zz zz10<c-e>

" insert dates, etc
" unmap <leader> d 
nnoremap <leader>id "=strftime("%Y-%m-%d %H:%M")<CR>P
nnoremap <leader>im "="= " . strftime("%Y-%m-%d %H:%M")<CR>P

nnoremap <silent> <leader>fq :call FixQuotes()<CR>
nnoremap <silent> <leader>fs :call FixTrailingWhitespace()<CR>

nmap <silent> <leader>ts :call ToggleWhitespace()<CR>
noremap <silent> <Leader>tw :call ToggleWrap()<CR>
noremap <silent> <Leader>z :call ToggleWrap()<CR>
nmap <silent> <Leader>tp :ToggleProse<CR>
" nmap <silent> <Leader>tt :ToggleTypewriter<CR>

" unmap s
noremap ss s

" i always want linewise
noremap v V
noremap V v

nmap <leader>c gcc
vmap <leader>c gc
" map <leader>n :cnext<cr>

map <silent> <Leader>gl :call OpenURI()<CR>

" google the word under the cursor
nmap <silent> <leader>gg "gyiw:call GoogleSearch()<CR>
nmap <silent> <leader>gi' "gyi':call GoogleSearch()<CR>
nmap <silent> <leader>gi" "gyi":call GoogleSearch()<CR>

" google the visual selection
vmap <silent> <leader>gg "gy:call GoogleSearch()<CR>

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

"Rainbow Parentheses Always on
"au VimEnter * RainbowParenthesesToggleAll
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

"let g:mustache_abbreviations = 1

" nnoremap <leader>3 :call ChangeSoftTabs(input("from: "), input("to: "))<CR>
nnoremap <leader>43 :call ChangeSoftTabs(4, 3)<CR>
nnoremap <leader>34 :call ChangeSoftTabs(3, 4)<CR>

