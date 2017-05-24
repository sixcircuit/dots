
let g:ycm_cache_omnifunc = 1

" set timeoutlen=200

" sqa creates a new session no matter what

" add lines easily with + and -
nnoremap + maO<esc>`a
nnoremap - mao<esc>`a

" ' now goes to the mark line and column, instead of just the line
nnoremap ' `
nnoremap ` '

" navigate windows easily
noremap <C-n> <C-w>w

" timestamp in insert mode
" unmap <leader> d 
nnoremap <leader>d "=strftime("%Y-%m-%d %H:%M")<CR>P
nnoremap <leader>t "="= " . tolower(strftime("%A")) . " { who: who, answer: answer, mood: mood, bdc: bdc, stress: stress, chest: chest, notes: notes }"<CR>P

vmap <leader>a :!summer<CR>

" noremap <C-h> <C-w><
" noremap <C-l> <C-w>>
" noremap <C-j> <C-w>h
" noremap <C-k> <C-w>l

noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k

noremap <left> <C-w><
noremap <right> <C-w>>
noremap <up> <C-w>+
noremap <down> <C-w>-

" navigate windows easily end


" clear search highlighting
nnoremap <leader>/ :noh<cr>

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

" CommandT

set wildignore+=*.o,*.obj,.git,node_modules,build

" let g:CommandTWildIgnore=&wildignore 

" let g:CommandTWildIgnore=&wildignore . ",**/bower_components/*"

" uses find as a fallback
" let g:CommandTFileScanner = "find"

" file, dir, or pwd (which doesn't scan)
let g:CommandTTraverseSCM = "pwd"

" show best match at bottom
let g:CommandTMatchWindowReverse = 0

" show match window at top
let g:CommandTMatchWindowAtTop = 1

" take up all the space
let g:CommandTMaxHeight = 0

" nnoremap <leader>o call CommandTCancel()

" highlight line
let g:CommandTHighlightColor = "CursorLine"

" cancel match window
" let g:CommandTCancelMap='<c-o>'
nnoremap <leader>o :CommandT<cr>
nnoremap <leader>l :CommandTBuffer<cr>

" end CommandT

map <leader>c<leader> :TComment<cr>

nnoremap <leader>h :RainbowParenthesesToggleAll<cr>

" reformat buffer
nnoremap <leader>= ggvG=``

" cycle between tabs c-t forware c-p backward
nnoremap <silent> <C-t> :tabn<cr>
nnoremap <silent> <C-p> :tabp<cr>

" nnoremap <C-n> :tabnew<cr>
nnoremap t1 :tabm 0<cr>
nnoremap t2 :tabm 1<cr>
nnoremap t3 :tabm 2<cr>
nnoremap t4 :tabm 3<cr>
nnoremap t5 :tabm 4<cr>
nnoremap t6 :tabm 5<cr>
nnoremap t7 :tabm 6<cr>
nnoremap t8 :tabm 7<cr>
nnoremap t9 :tabm 8<cr>

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

" UtilSnips Start
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.

let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" End UtiliSnips

" Easy Motion

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'
" let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj;'

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;'

" set easy motion to just leader, instead of leader, leader
map <Leader> <Plug>(easymotion-prefix)

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-s)

" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" map <Leader>l <Plug>(easymotion-special-l)
" map <Leader>p <Plug>(easymotion-special-p)


" map <Leader>w <Plug>(easymotion-jumptoanywhere)
map <Leader>w <Plug>(easymotion-w)
map <Leader>b <Plug>(easymotion-b)

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

map <Leader>s <Plug>(easymotion-jumptoanywhere)
" map <Leader>w <Plug>(easymotion-jumptoanywhere)
" map <Leader>cc <Plug>(easymotion-jumptoanywhere)
" i would need to change the next one, because it slows down regular /
" map // <Plug>(easymotion-sn) 

" use arrows to switch buffers
" let g:miniBufExplMapWindowNavArrows = 1

let g:powerline_config_overrides = {'common': {'default_top_theme': 'ascii'}}

map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
" map zg/ <Plug>(incsearch-fuzzy-stay)

"Rainbow Parentheses Always on
"au VimEnter * RainbowParenthesesToggleAll
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

"let g:mustache_abbreviations = 1

" You Complete Me
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_min_num_of_chars_for_completion = 2
" let g:ycm_key_invoke_completion = '<Space-g>'
