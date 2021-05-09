
" 256 colors
set t_Co=256

set background=dark
" set background=light

let g:solarized_grayscale=1
" let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
" let g:solarized_contrast = "higher"
let g:solarized_termcolors=256
" let g:solarized_termcolors=16
colorscheme solarized

" highlight Normal ctermfg=grey ctermbg=NONE

"drop text background color
" highlight Normal ctermbg=NONE

"black gutter for line numbers
highlight clear LineNr
" highlight LineNr ctermfg=grey ctermbg=black
" highlight LineNr ctermfg=black 
highlight LineNr ctermfg=238
"highlight LineNr ctermbg=235
highlight TabLine ctermbg=NONE
highlight TabLineFill ctermbg=NONE



" These are changes for solarized
highlight MatchParen cterm=bold ctermbg=NONE

" hi EasyMotionShade  ctermbg=none ctermfg=grey
hi link EasyMotionShade  Comment
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=red

hi EasyMotionIncSearch ctermbg=none ctermfg=red
hi EasyMotionMoveHL ctermbg=none ctermfg=red
" hi EasyMotionIncCursor ctermbg=none 

" hi link EasyMotionShade  Comment
" hi link EasyMotionTarget ErrorMsg
" hi link EasyMotionTarget2First ErrorMsg
" hi link EasyMotionTarget2Second ErrorMsg


hi CursorLine ctermbg=235 guibg=#262626
" hi CursorLine term=reverse ctermbg=235 guibg=#262626
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

