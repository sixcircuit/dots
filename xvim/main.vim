
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

let g:no_fancy_highlighting=1

execute 'set runtimepath+=' . s:root . '/runtime'

function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')
    call SourceFile(s:fpath)
  endfor
  for s:fpath in split(globpath(a:file, '*.lua'), '\n')
    call SourceFile(s:fpath)
  endfor
endfunction

function! SourceFile(file)
  " echo 'source abs: ' . a:file
  exe 'source ' . a:file
endfunction

call SourceDirectory(s:root . "/baseline")

" set backspace=""

call plug#begin()

call SourceFile(s:root . "/plugins.vim")

call plug#end()


call SourceDirectory(s:root . "/functions")
call SourceDirectory(s:root . "/plugins")
call SourceDirectory(s:root . "/settings")

call SourceFile(s:root . "/keymaps.vim")
call SourceFile(s:root . "/keymaps.lua")

" allow project specific settings -- needs to be at the end
call SourceFile(s:root . "/localrc.vim")

colorscheme kendrick
