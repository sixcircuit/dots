
set path+=**

" set foldmethod=indent
" I don't use folds, so set it to the fastest option
set foldmethod=manual

" set shell to interactive so it sources my path and aliases
" this does weird job control stuff for .rb files and git diff
"set shell=/bin/zsh\ -li

" edit temp files in place, for crontab mostly
set backupskip=/tmp/*,/private/tmp/*" 

" don't show the preview window while coding, I don't care about docs
set completeopt-=preview

" setup spell check
set spell spelllang=en_us
set spellcapcheck=

" no automatic eol 
set noeol 

" enable yank to clipboard
set clipboard=unnamed
"set clipboard=unnamedplus

"Set where to store backups
set backupdir=/tmp

" Set where to store swap files
set dir=/tmp  

" 256 colors
set t_Co=256

" set visual bell off
set novisualbell

" it's 2012
set encoding=utf-8

" you know, set the history
set history=1000

" don't use modelines
set modelines=4

" Intuitive backspacing in insert mode
set backspace=indent,eol,start

" tell vim we're fast so redraw more for smother action
set ttyfast

" always show status bar
set laststatus=2
" always show tabline
set showtabline=2

" use persistent undos
" set undofile

" set the window title and other window stuff
set title
set showcmd

" set text prompts to press a key when you shell out, etc.
set shortmess=atI

" background buffers don't have to be saved
set hidden

" don't wrap text
set nowrap

" don't need to be compatible with old vim
set nocompatible

" show line numbers, not relatively
set nu
" set relativenumber
set ruler

" minimum lines above/below cursor
set scrolloff=4

"" set auto indent
set autoindent

" set indent to 3 spaces and expand
set ts=3
set shiftwidth=3
set expandtab
set softtabstop=3

" show bracket matches
set showmatch

" ignore case in search
set ignorecase

" pay attention to case when caps are used
set smartcase

" Highlight search terms...
set hlsearch
set incsearch " ...dynamically as they are typed.

" disable code folding
set nofoldenable

" add fancy features
syntax on
filetype on
filetype plugin on
filetype indent on
runtime macros/matchit.vim

" set completion menu
set wildmenu

"  complete till ambiguous, like a shell
set wildmode=list:longest

" load my settings 
source ~/.xvix/index.vim


"set cursor line
set cursorline
" set cursorcolumn

" only show filename in tab
set guitablabel=%t

" highlight long lines
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.*/

" remove show mode, it has to be here for whatever reason
set noshowmode 

"remove right scroll bar in macvim fullscreen
set guioptions-=r 


filetype plugin indent on


" allow project specific settings

set secure

call localrc#load('.tree.vimrc', getcwd())

