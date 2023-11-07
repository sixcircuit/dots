
set sessionoptions-=options

" if you call vim with arguments, we don't engage the session code

let g:auto_session_root = $HOME . "/.nvim_sessions"

function! UpdateSessionPaths()
   if !exists("g:auto_session_root")
      let g:auto_session_root = $HOME . "/.nvim/sessions"
   endif
   let b:session_dir = g:auto_session_root . getcwd()
   let b:session_file = b:session_dir . "/session.vim"
endfunction

" Creates a session
function! MakeSession()
   call UpdateSessionPaths()
   if (filewritable(b:session_dir) != 2)
      exe 'silent !mkdir -p "' . b:session_dir . '"'
      redraw!
   endif
   exe "mksession! " . b:session_file
   echo "Session created:" b:session_file
endfunction

" Updates a session, or creates one if it doesn't exist
function! UpdateSession()
   if argc() == 0
      call UpdateSessionPaths()
      if (filereadable(b:session_file))
         exe "mksession! " . b:session_file
         echo "Session updated:" b:session_file
      else
         call MakeSession()
      endif
   endif
endfunction

" Loads a session if it exists
function! LoadSession()
   if argc() == 0
      call UpdateSessionPaths()
      if (filereadable(b:session_file))
         " echo "Session loaded:" b:session_file
         echo "Session loaded." 
         exe 'source ' b:session_file
      else
         " echo "No session loaded."
      endif
   else
      let b:session_file = ""
      let b:session_dir = ""
   endif
endfunction

au VimEnter * nested :call LoadSession()
au VimLeave * :call UpdateSession()
" au BufEnter * nested :call UpdateSession()

