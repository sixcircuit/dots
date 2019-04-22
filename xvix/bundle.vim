
" must setup neobundle before you get here. see .vimrc and .nvimrc

NeoBundleFetch 'Shougo/neobundle.vim'

" END NeoBundle Required

" You can specify revision/branch/tag.
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

NeoBundle 'wincent/Command-T', {
 \   'build_commands': ['make', 'ruby'],
 \   'build': {
 \      'unix': 'cd ruby/command-t/ext/command-t && { make clean; ruby extconf.rb && make }'
 \   }
 \ }

NeoBundle 'Lokaltog/vim-easymotion'

" NeoBundle 'vim-scripts/Gummybears'
"
NeoBundle 'sktaylor/vim-colors-solarized'
" NeoBundle 'altercation/vim-colors-solarized'
"
NeoBundle 'mileszs/ack.vim'

NeoBundle 'tpope/vim-surround'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'bkad/CamelCaseMotion'
NeoBundle 'tpope/vim-repeat'
" NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'sjl/gundo.vim'

NeoBundle 'Valloric/MatchTagAlways'

NeoBundle 'kien/rainbow_parentheses.vim'

NeoBundle 'groenewege/vim-less'
NeoBundle 'mustache/vim-mustache-handlebars'
NeoBundle 'hashivim/vim-terraform'
NeoBundle 'vim-scripts/Cpp11-Syntax-Support'
NeoBundle 'sktaylor/vim-javascript'
" NeoBundle 'pangloss/vim-javascript'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'othree/html5.vim'
"
NeoBundle 'nathanaelkane/vim-indent-guides'

" NeoBundle 'tpope/vim-eunuch'
" NeoBundle 'tpope/vim-obsession'

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
" call neobundle#end()

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
" NeoBundleCheck

