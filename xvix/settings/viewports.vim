
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

