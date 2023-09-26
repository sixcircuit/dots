
" ignore case in search
set ignorecase

" pay attention to case when caps are used
set smartcase

" Highlight search terms...
set hlsearch
set incsearch " ...dynamically as they are typed.

" use standard regexes, not vim regexes
nnoremap / /\v
vnoremap / /\v

" clear search highlighting
nnoremap <leader>/ :noh<cr>

