
" uses find as a fallback
" let g:CommandTFileScanner = "find"

" let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" echo "PATH: " . s:path

" file, dir, or pwd (which doesn't scan)
" let g:CommandTTraverseSCM = "pwd"
"
" " show best match at bottom
" let g:CommandTMatchWindowReverse = 0
"
" " show match window at top
" let g:CommandTMatchWindowAtTop = 1
"
" " take up all the space
" let g:CommandTMaxHeight = 0
"
" " nnoremap <leader>o call CommandTCancel()
"
" " highlight line
" let g:CommandTHighlightColor = "CursorLine"
"
" let g:CommandTAcceptSelectionCommand = 'e'
" let g:CommandTAcceptSelectionSplitCommand = 'sp'
" let g:CommandTAcceptSelectionTabCommand = 'tabe'
" " let g:CommandTAcceptSelectionTabCommand = 'CommandTOpen tabe'
" let g:CommandTAcceptSelectionVSplitCommand = 'vs'
"
" cancel match window
" let g:CommandTCancelMap='<c-o>'
" nnoremap <leader>o :CommandTRipgrep<cr>
nnoremap <leader>l :CommandT<cr>
" this excludes some files. see the code.
nnoremap <leader>o :CommandTFind<cr>
" nnoremap <leader>l :CommandTBuffer<cr>

