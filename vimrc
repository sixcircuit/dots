
set rubydll=~/.rvm/rubies/ruby-2.5.1/lib/libruby.2.5.dylib

" START NeoBundle Required

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" END NeoBundle Required

" You can specify revision/branch/tag.
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" My Bundles here:
NeoBundle 'wincent/Command-T'
NeoBundle 'vim-scripts/Gummybears'
NeoBundle 'sktaylor/vim-colors-solarized'
" NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Valloric/YouCompleteMe'

NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'bkad/CamelCaseMotion'
NeoBundle 'mustache/vim-mustache-handlebars'
NeoBundle 'tpope/vim-surround'
NeoBundle 'groenewege/vim-less'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'hashivim/vim-terraform'
NeoBundle 'vim-scripts/Cpp11-Syntax-Support'
NeoBundle 'sktaylor/vim-javascript'
NeoBundle 'nathanaelkane/vim-indent-guides'
" NeoBundle 'marijnh/tern_for_vim'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'Valloric/MatchTagAlways'
"
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'othree/html5.vim'
NeoBundle 'tpope/vim-eunuch'
" NeoBundle 'tpope/vim-obsession'
" NeoBundle 'Raimondi/delimitMate'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'Keithbsmiley/swift.vim'

NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'haya14busa/incsearch-fuzzy.vim'
NeoBundle 'thinca/vim-localrc'

NeoBundle 'christoomey/vim-titlecase'

" ultisnips
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'
" end ultisnips


" NeoBundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

NeoBundle 'sixcircuit/powerline', {'rtp': 'powerline/bindings/vim/'}

" NeoBundle 'itchyny/lightline.vim'
" NeoBundle 'vim-airline/vim-airline'
" NeoBundle 'vim-airline/vim-airline-themes'

" NeoBundle 'vim-powerline'
" NeoBundle 'Lokaltog/vim-powerline', { 'rev' : 'develop' }

NeoBundle 'mkitt/tabline.vim'

" START NeoBundle Required
call neobundle#end()

"Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" END NeoBundle Required

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

" set visual bell
set vb

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
"set showcmd

" use standard regexes, not vim regexes
nnoremap / /\v
vnoremap / /\v

" set text prompts to press a key when you shell out, etc.
set shortmess=atI

" map leader to space
let mapleader = " "

" one less key for command mode
nnoremap ; :
vnoremap ; :

nnoremap ( %

" use increment inside tmux or screen 
" nnoremap <C-e> <C-a>

" background buffers don't have to be saved
set hidden

" don't wrap text
set nowrap

" if you do later have the wrap be sane
set breakindent
set showbreak=\ \ 

" don't need to be compatible with old vim
set nocompatible

" show line numbers, not relatively
set nu
" set relativenumber
set ruler

" minimum lines above/below cursor
set scrolloff=4

" scroll the viewport faster with ctrl-y and ctrl-e
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

"" set auto indent
set autoindent

" set indent to 4 spaces and expand
set ts=4
set shiftwidth=4
set expandtab
set softtabstop=4

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

" see whitespace
"set list
"set listchars=tab:>-,eol:¬
" set listchars=tab:▸\ ,trail:·
set listchars=tab:▸\ ,trail:·


" turn visible whitespace off when requested
" nmap <silent> <leader>v :set nolist!<CR>

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

set background=dark
" set background=light

" let g:solarized_visibility = "high"
" let g:solarized_contrast = "high"
let g:solarized_termcolors=256
" let g:solarized_termcolors=16
colorscheme solarized

" load my settings 
runtime custom/index.vim
" highlight Normal ctermfg=grey ctermbg=NONE

"drop text background color
" highlight Normal ctermbg=NONE

"black gutter for line numbers
highlight clear LineNr
" highlight LineNr ctermfg=grey ctermbg=black
" highlight LineNr ctermfg=black 
highlight LineNr ctermfg=238
highlight TabLine ctermbg=NONE
highlight TabLineFill ctermbg=NONE

"set cursor line
set cursorline
"set cursorcolumn
hi CursorLine ctermbg=235 guibg=#262626
" hi CursorLine term=reverse ctermbg=235 guibg=#262626
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" only show filename in tab
set guitablabel=%t

" highlight long lines
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.*/

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

" remove show mode, it has to be here for whatever reason
set noshowmode 

"remove right scroll bar in macvim fullscreen
set guioptions-=r 

" check for changes
" set autoread "this would work in gvim
" but instead we use a script that provieds the following function
let autoreadargs={'autoread':1} 
execute WatchForChanges("*",autoreadargs) 


noremap <silent> <Leader>z :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    " set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
    silent! iunmap <buffer> k
    silent! iunmap <buffer> j
    silent! iunmap <buffer> 0
    silent! iunmap <buffer> $
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    " set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
  endif
endfunction

" allow project specific settings

set secure

call localrc#load('.tree.vimrc', getcwd())

