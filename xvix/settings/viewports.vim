
set splitbelow
set splitright

" windows

" scroll the viewport faster with ctrl-y and ctrl-e
nnoremap <C-j> 5<C-e>
nnoremap <C-k> 5<C-y>

" navigate windows easily
noremap <C-n> <C-w>w

" resize windows easily

" noremap <silent> <left> :exe 'vertical resize ' . (winwidth('%') * 1/3)<CR>
" noremap <left> :echo 'vertical resize ' . (winheight('%') * 3/2)<CR>

function! SwitchToWindow(win_index)
   exe a:win_index . "wincmd w"
endfunction

function! SwitchToNextWindow()
   exe "wincmd w"
endfunction


function! RotatePanes()
   exe "wincmd r"
endfunction

function! SplitWindow()
   exe 'vs'
endfunction

function! ResizeCurrentWindow(size)
   exe 'vertical resize ' . a:size
endfunction

function! ResizeWindow(win_index, size)
   let cur_win = winnr()
   call SwitchToWindow(a:win_index)
   call ResizeCurrentWindow(a:size)
   call SwitchToWindow(l:cur_win)
endfunction

function! LayoutWindows()

   let cur_win = winnr()
   let cur_win_width = winwidth(cur_win)
   let all_cols = &columns
   let panes = winnr('$')

   let first_split_small = 65
   let second_split_small = 85

   let first_split_big = 83 " same as = on big screen (for 17 font size)
   " let first_split_big = 93 " same as = on big screen (for 15 font size)
   " let second_split_big = 100

   " terminal windows - 10

   if all_cols <= 250
      if panes == 1
         call SplitWindow()
         call SwitchToWindow(2)
         call ResizeWindow(1, first_split_small)

      elseif panes == 2
         call ResizeWindow(1, first_split_small)

      elseif panes == 3
         call ResizeWindow(1, first_split_small)
         call ResizeWindow(2, second_split_small)

      else
        exe "wincmd ="

      endif

   else " big screen

      if panes == 1
         call SplitWindow()
         call SplitWindow()
         call SwitchToWindow(2)
         exe "wincmd ="
         " call ResizeWindow(1, first_split_big)

      elseif panes == 2
         call ResizeWindow(1, first_split_big)

      elseif panes == 3
         exe "wincmd ="
         " call ResizeWindow(1, first_split_big)
         " call ResizeWindow(2, second_split_big)

      else
         exe "wincmd ="

      endif

   endif

endfunction

" ((n % m) + m) % m` or `((-10 % 3) + 3) % 3` returns `2`
" function! s:mod(n,m)
  " return ((a:n % a:m) + a:m) % a:m
" endfunction

" TODO: i'd like this to be smart and rotate till i'm at a new file.
" i keep a, b, b open for the 3 column layout. and i'd like to switch between
" a or b and stay in the center
function! RotateWindowsKeepCursor()
   let cur_win = winnr()
   let panes = winnr('$')

   " if panes == 2
      call RotatePanes()
      call SwitchToWindow(cur_win)

   " elseif panes == 3
   "    call RotatePanes()
   "    call RotatePanes()
   "    call SwitchToWindow(cur_win)
   "
   " elseif panes == 4
   "    call RotatePanes()
   "    call RotatePanes()
   "    call RotatePanes()
   "    call SwitchToWindow(cur_win)
   " endif

   call LayoutWindows()

endfunction

nnoremap <leader>r :call RotateWindowsKeepCursor()<CR>

noremap <silent> <down> :vertical resize -10<CR>
noremap <silent> <up> :vertical resize +10<CR>
" noremap <silent> <left> :vertical resize 80<CR>
noremap <silent> \ :call LayoutWindows()<CR>
" noremap <silent> \ <C-w>=


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

