
set sessionoptions-=options

" if you call vim with arguments, we don't engage the session code

" Creates a session
function! MakeSession()
    echo "Session created."
    let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
    if (filewritable(b:sessiondir) != 2)
        exe 'silent !mkdir -p ' b:sessiondir
        redraw!
    endif
    let b:sessionfile = b:sessiondir . '/session.vim'
    exe "mksession! " . b:sessionfile
endfunction

" Updates a session, or creates one if it doesn't exist
function! UpdateSession()
    if argc() == 0
        let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
        let b:sessionfile = b:sessiondir . "/session.vim"
        if (filereadable(b:sessionfile))
            exe "mksession! " . b:sessionfile
            echo "Session updated."
        else
            call MakeSession()
        endif
    endif
endfunction

" Loads a session if it exists
function! LoadSession()
    if argc() == 0
        let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
        let b:sessionfile = b:sessiondir . "/session.vim"
        if (filereadable(b:sessionfile))
            exe 'source ' b:sessionfile
            echo "Session loaded."
        else
            echo "No session loaded."
        endif
    else
        let b:sessionfile = ""
        let b:sessiondir = ""
    endif
endfunction

au VimEnter * nested :call LoadSession()
au VimLeave * :call UpdateSession()
" au BufEnter * nested :call UpdateSession()

noremap sqa :call MakeSession() <CR>:qa<CR>





