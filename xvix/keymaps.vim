
" https://www.johnhawthorn.com/2012/09/vi-escape-delays/
" one part of fixing slow / missing escapes in nvim
set timeoutlen=1000 ttimeoutlen=0
" set timeoutlen=200

" core remaps

" one less key for command mode
nnoremap ; :
vnoremap ; :

" ' now goes to the mark line and column, instead of just the line
nnoremap ' `
nnoremap ` '

" yank till the end of the line
noremap Y y$

noremap M %

" add lines easily with + and -
nnoremap + maO<esc>`a
nnoremap - mao<esc>`a

nnoremap <leader>ye y$
nnoremap <leader>yb y^
nnoremap <leader>y0 y^

nmap <leader>mb ysiW)


nnoremap <silent> <leader>fq :call FixQuotes()<CR>
nnoremap <silent> <leader>fs :call FixTrailingWhitespace()<CR>

nmap <silent> <leader>ts :call ToggleWhitespace()<CR>
noremap <silent> <Leader>tw :call ToggleWrap()<CR>
noremap <silent> <Leader>z :call ToggleWrap()<CR>
nmap <silent> <Leader>tp :ToggleProse<CR>
" nmap <silent> <Leader>tt :ToggleTypewriter<CR>


map <leader>c :TComment<cr>

map <Leader>g :call OpenURI()<CR>

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

nnoremap <leader>h :RainbowParenthesesToggleAll<cr>

" reformat buffer
nnoremap <leader>= ggvG=``

" capitalization mappings
if (&tildeop)
  nmap gcw guw~l
  nmap gcW guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$ gu$~l
  nmap gcgc guu~l
  nmap gcc guu~l
  vmap gc gu~l
else
  nmap gcw guw~h
  nmap gcW guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$ gu$~h
  nmap gcgc guu~h
  nmap gcc guu~h
  vmap gc gu~h
endif


map ? <Plug>(incsearch-fuzzy-/)
" map ? <Plug>(incsearch-fuzzy-?)
" map zg/ <Plug>(incsearch-fuzzy-stay)

"Rainbow Parentheses Always on
"au VimEnter * RainbowParenthesesToggleAll
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

"let g:mustache_abbreviations = 1

" nnoremap <leader>3 :call ChangeSoftTabs(input("from: "), input("to: "))<CR>
nnoremap <leader>43 :call ChangeSoftTabs(4, 3)<CR>
nnoremap <leader>34 :call ChangeSoftTabs(3, 4)<CR>



