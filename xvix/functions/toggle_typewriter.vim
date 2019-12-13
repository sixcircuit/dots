
" function! s:goyo_enter()
"   if executable('tmux') && strlen($TMUX)
"     silent !tmux set status off
"     silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
"   endif
"   set noshowmode
"   set noshowcmd
"   set scrolloff=999
"   Limelight
"   " ...
" endfunction
"
" function! s:goyo_leave()
"   if executable('tmux') && strlen($TMUX)
"     silent !tmux set status on
"     silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
"   endif
"   set showmode
"   set showcmd
"   set scrolloff=5
"   Limelight!
"   " ...
" endfunction
"

function! s:goyo_enter()
   call WrapOn()
   set scrolloff=999
endfunction

function! s:goyo_leave()
   set scrolloff=5
   call WrapOff()
   highlight clear LineNr
   highlight LineNr ctermfg=238
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

function! ToggleTypewriter()
  call goyo#execute(0, [])
  " set spell noci nosi noai nolist noshowmode noshowcmd
  " set complete+=s
  " set bg=light
  " if !has('gui_running')
    " let g:solarized_termcolors=256
  " endif
  " colors solarized
endfunction

command! ToggleTypewriter call ToggleTypewriter()

function! ToggleProse()
  call goyo#execute(0, [])
  " set spell noci nosi noai nolist noshowmode noshowcmd
  " set complete+=s
  " set bg=light
  " if !has('gui_running')
    " let g:solarized_termcolors=256
  " endif
  " colors solarized
endfunction

command! ToggleProse call ToggleProse()

let g:twm_allowed_pat = "^[[:alnum:] \t\r,.!?'\"]$"

" start typewrite mode (stop with CTRL-C):
nmap <Leader>tw <Plug>twm

nmap <script> <Plug>twm i<SID>m_
imap <Plug>twm <SID>m_

" <SID>m_ causes a "_" to show up in the text.
" <SID>m_<Esc> is mapped to give Vim something to wait for.
imap <SID>m_<Esc> <SID>m_
ino <silent> <SID>m_ <C-R>=TwGetchar()<CR>

func! TwGetchar()
    if getchar(1)
        let chr = s:getchar()
    else
        let chr = "\<Plug>"
    endif
    call feedkeys("\<Plug>twm")
    if chr =~ g:twm_allowed_pat
        return chr
    endif
    return ""
endfunc

func! s:getchar()
    let chr = getchar()
    if chr != 0
        let chr = nr2char(chr)
    endif
    return chr
endfunc


