
au BufNewFile,BufRead *.json set filetype=json
au BufNewFile,BufRead *.html.mu set filetype=html
au BufNewFile,BufRead *.html.hb set filetype=html
au BufNewFile,BufRead *.sh.hb set filetype=bash
au BufNewFile,BufRead Dockerfile.hb set filetype=dockerfile
"au BufNewFile,BufRead *.less set filetype=css
au BufNewFile,BufRead *.js.mu set filetype=javascript
au BufNewFile,BufRead *.js.hb set filetype=javascript
au BufNewFile,BufRead *.tjs set filetype=javascript
au BufNewFile,BufRead *.tjs.mu set filetype=javascript
" au BufNewFile,BufRead *.tjs.mu set filetype=javascript syntax=mustache 
au BufNewFile,BufRead *.tjs.hb set filetype=javascript
au BufNewFile,BufRead *.xml.hb set filetype=xml
au BufNewFile,BufRead *.swift.hb set filetype=swift 
au BufNewFile,BufRead *.swift.mu set filetype=swift
au BufNewFile,BufRead SConstruct set filetype=python
au BufNewFile,BufRead SConscript set filetype=python
au BufNewFile,BufRead *.cpp set syntax=cpp11

autocmd FileType terraform setlocal commentstring=#%s

" autocmd BufNewFile,BufRead .*.tame.js setlocal wrap linebreak
autocmd BufNewFile,BufRead *.tame.js setlocal readonly nomodifiable

" call SolarizedSetNormal()

autocmd BufEnter,FileType * 
\   if &ft ==# 'javascript' | call SolarizedSetNormal() | endif

" autocmd BufEnter,FileType * 
" \   if &ft ==# 'javascript' | call SolarizedBoldNormal() | endif

" autocmd BufEnter,FileType * 
" \   if &ft ==# 'javascript' || &ft ==# 'cpp' | colorscheme darkblue |
" \   elseif &ft ==? 'r' | colorscheme desert |
" \   else | colorscheme default |
" \   endif
