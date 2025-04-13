
" don't readjust the splits when we create and delete them
set noequalalways

" tell vim we're fast so redraw more for smother action
set ttyfast

" set visual bell off
set novisualbell

" always show status bar
set laststatus=2

" set the window title and other window stuff
set title
set showcmd

" set text prompts to press a key when you shell out, etc.
" set shortmess=atI
set shortmess=OatI

" fix press enter to open issue with some files
" set shortmess=Ot

" show line numbers
set nu

" not relatively
" set relativenumber

set ruler

" minimum lines above/below cursor
set scrolloff=5

" set completion menu
set wildmenu

"  complete till ambiguous, like a shell
set wildmode=list:longest


" highlight long lines
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.*/

" remove show mode
set noshowmode

"remove right scroll bar in macvim fullscreen
set guioptions-=r

"set cursor line
set cursorline

" set cursorcolumn

" only show filename in tab
set guitablabel=%t

" don't wrap text
set nowrap

" show bracket matches
set showmatch
runtime macros/matchit.vim

" set foldmethod=indent
" I don't use folds, so set it to the fastest option
set foldmethod=manual

" disable code folding
set nofoldenable

" don't show the preview window while coding, I don't care about docs
set completeopt-=preview

