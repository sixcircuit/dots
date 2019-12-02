
" core remaps

" use standard regexes, not vim regexes
nnoremap / /\v
vnoremap / /\v

" one less key for command mode
nnoremap ; :
vnoremap ; :

" ' now goes to the mark line and column, instead of just the line
nnoremap ' `
nnoremap ` '


noremap M %


" clear search highlighting
nnoremap <leader>/ :noh<cr>


" windows

" scroll the viewport faster with ctrl-y and ctrl-e
nnoremap <C-j> 5<C-e>
nnoremap <C-k> 5<C-y>

" navigate windows easily
noremap <C-n> <C-w>w

" resize windows easily

" noremap <silent> <left> :exe 'vertical resize ' . (winwidth('%') * 1/3)<CR>
" noremap <left> :echo 'vertical resize ' . (winheight('%') * 3/2)<CR>

function! ResizeToPerfect()
   exe 'vertical resize ' . (&columns - 76)
endfunction

nnoremap <leader>r <C-w>r <C-w>w :call ResizeToPerfect()<CR>

noremap <silent> <down> :vertical resize -10<CR>
noremap <silent> <up> :vertical resize +10<CR>
noremap <silent> <left> :vertical resize 75<CR>
noremap <silent> <right> :call ResizeToPerfect()<CR>



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
nmap <silent> <Leader>tt :ToggleTypewriter<CR>


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

map <leader>c :TComment<cr>

nnoremap <leader>h :RainbowParenthesesToggleAll<cr>

" reformat buffer
nnoremap <leader>= ggvG=``

" cycle between tabs c-t forware c-p backward
" nnoremap <silent> <C-t> :tabn<cr>
" nnoremap <silent> <C-p> :tabp<cr>

" nnoremap <C-n> :tabnew<cr>
nnoremap <silent> <C-h> :tabp<cr>
nnoremap <silent> <C-l> :tabn<cr>
nnoremap <silent> <C-p> :tabm -1<cr>
nnoremap <silent> <C-t> :tabm +1<cr>

" nnoremap t8 :tabm 7<cr>
" nnoremap t9 :tabm 8<cr>

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

call camelcasemotion#CreateMotionMappings(',')

" Easy Motion

let g:EasyMotion_do_mapping = 0 " Disable default mappings

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;'
" let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj;'
" let g:EasyMotion_keys = 'asdklghqwertyuiopzxcvbnmfj'

" let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;'

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

map ? <Plug>(incsearch-fuzzy-/)
" map ? <Plug>(incsearch-fuzzy-?)
" map zg/ <Plug>(incsearch-fuzzy-stay)

"Rainbow Parentheses Always on
"au VimEnter * RainbowParenthesesToggleAll
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

"let g:mustache_abbreviations = 1

function! ChangeSoftTabs(from, to)
   execute "set ts=" . a:from . " noexpandtab"
   execute "retab!"
   execute "set expandtab ts=" . a:to
   execute "retab!"
endfunction

" nnoremap <leader>3 :call ChangeSoftTabs(input("from: "), input("to: "))<CR>
nnoremap <leader>43 :call ChangeSoftTabs(4, 3)<CR>
nnoremap <leader>34 :call ChangeSoftTabs(3, 4)<CR>

"
"
"
" You Complete Me

let g:ycm_cache_omnifunc = 1

let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_min_num_of_chars_for_completion = 2
" let g:ycm_key_invoke_completion = '<Space-g>'

ruby << EOF
  def open_uri
    re = %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}

    line = VIM::Buffer.current.line

    if url = line[re]
      system("open", url)
      VIM::message(url)
    else
      VIM::message("No URI found in line.")
    end
  end
EOF

if !exists("*OpenURI")
  function! OpenURI()
    :ruby open_uri
  endfunction
endif
map <Leader>g :call OpenURI()<CR>



let delimitMate_expand_cr = 1

