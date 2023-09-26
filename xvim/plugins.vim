" mut setup vim-plug before you get here. see .vimrc and .nvimrc

" Plug 'vim-scripts/Gummybears'
" Plug 'altercation/vim-colors-solarized'
" Plug 'mileszs/ack.vim'
" Plug 'sktaylor/vim-javascript'
" Plug 'tpope/vim-eunuch'
" Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-fugitive'
" Plug 'jiangmiao/auto-pairs'
" Plug 'vim-scripts/auto-pairs-gentle'

Plug 'Lokaltog/vim-easymotion'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

Plug 'jremmen/vim-ripgrep'

Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'bkad/CamelCaseMotion'

Plug 'tpope/vim-repeat'

" Plug 'ycm-core/YouCompleteMe'

Plug 'jiangmiao/auto-pairs'

" this is a hack that tricks auto-pairs into not breaking command-t. all other
" bracket completion plugins completely blow up when we use backspace in the
" command-t completion window.
autocmd FileType CommandTPrompt let b:autopairs_loaded=1

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

"
Plug 'pangloss/vim-javascript'

" i use this.
Plug 'ervandew/supertab'

Plug 'sjl/gundo.vim'
Plug 'Valloric/MatchTagAlways'

" fun but I don't use them
" Plug 'kien/rainbow_parentheses.vim'

Plug 'groenewege/vim-less'
Plug 'mustache/vim-mustache-handlebars'
Plug 'hashivim/vim-terraform'
Plug 'vim-scripts/Cpp11-Syntax-Support'

Plug 'tpope/vim-markdown'
Plug 'othree/html5.vim'

Plug 'nathanaelkane/vim-indent-guides'

" camel case, snake case
Plug 'tpope/vim-abolish' 

Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'thinca/vim-localrc'

Plug 'christoomey/vim-titlecase'

Plug 'Keithbsmiley/swift.vim'

"" NeoBundle 'vim-airline/vim-airline'
"" NeoBundle 'vim-airline/vim-airline-themes'

Plug 'itchyny/lightline.vim'

Plug 'mkitt/tabline.vim'

let g:CommandTPreferredImplementation='lua'

Plug 'wincent/command-t', { 'do': 'cd lua/wincent/commandt/lib && make' }

" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
"

" Plug 'sktaylor/vim-colors-solarized'

" Plug 'maxmx03/solarized.nvim'

