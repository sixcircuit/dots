let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')
    call SourceFile(s:fpath)
  endfor
  for s:fpath in split(globpath(a:file, '*.lua'), '\n')
    call SourceFile(s:fpath)
  endfor
endfunction

function! SourceFile(file)
  echo 'source abs: ' . a:file
  exe 'source ' . a:file
endfunction

let g:auto_session_root = $HOME . "/.nvim_sessions"

call SourceDirectory(s:root . "/baseline")

" set backspace=""

call plug#begin()

call SourceFile(s:root . "/plugins.vim")

call plug#end()


call SourceDirectory(s:root . "/functions")
call SourceDirectory(s:root . "/plugins")
call SourceDirectory(s:root . "/settings")

call SourceFile(s:root . "/keymaps.vim")

" allow project specific settings -- needs to be at the end
call SourceFile(s:root . "/localrc.vim")
