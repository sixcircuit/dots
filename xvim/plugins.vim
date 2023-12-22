" must setup vim-plug before you get here. see .vimrc and .nvimrc

" Plug 'pangloss/vim-javascript'

" Plug 'itchyny/vim-cursorword'
" let g:cursorword_delay=0

Plug 'haya14busa/is.vim'
Plug 'haya14busa/vim-asterisk'
let g:asterisk#keeppos = 1

Plug 'stevearc/oil.nvim'


" map *   <Plug>(asterisk-*)
" map #   <Plug>(asterisk-#)
" map g*  <Plug>(asterisk-g*)
" map g#  <Plug>(asterisk-g#)

" map *  <Plug>(asterisk-z*)
" map #  <Plug>(asterisk-z#)
" map g* <Plug>(asterisk-gz*)
" map g# <Plug>(asterisk-gz#)

map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)

Plug 'smoka7/hop.nvim'
" Plug 'rlane/pounce.nvim'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

Plug 'ggvgc/vim-fuzzysearch'

Plug 'jremmen/vim-ripgrep'
" Plug 'duane9/nvim-rg'

Plug 'tpope/vim-surround'
Plug 'bkad/CamelCaseMotion'

Plug 'tpope/vim-commentary'

" radical requires magium. number conversion with gA
Plug 'glts/vim-magnum'
Plug 'glts/vim-radical'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'


Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" the autocmd is a hack that tricks delimitmate into not breaking command-t. 
" if we don't do this it completely blows up when we use backspace in the
" command-t completion window.
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
autocmd FileType CommandTPrompt let b:loaded_delimitMate = 1

" the autocmd is a hack that tricks auto-pairs into not breaking command-t. 
" if we don't do this it completely blows up when we use backspace in the
" command-t completion window.
" Plug 'jiangmiao/auto-pairs'
" autocmd FileType CommandTPrompt let b:autopairs_loaded=1


" no longer supported
" Plug 'sjl/gundo.vim'
Plug 'simnalamburt/vim-mundo'

Plug 'Valloric/MatchTagAlways'

Plug 'groenewege/vim-less'
Plug 'mustache/vim-mustache-handlebars'
Plug 'hashivim/vim-terraform'
Plug 'vim-scripts/Cpp11-Syntax-Support'

Plug 'tpope/vim-markdown'
Plug 'othree/html5.vim'

Plug 'nathanaelkane/vim-indent-guides'

" camel case, snake case
Plug 'tpope/vim-abolish' 


Plug 'thinca/vim-localrc'

Plug 'christoomey/vim-titlecase'

Plug 'Keithbsmiley/swift.vim'

Plug 'itchyny/lightline.vim'
Plug 'mkitt/tabline.vim'


let g:CommandTPreferredImplementation='lua'

Plug 'wincent/command-t', { 'do': 'cd lua/wincent/commandt/lib && make' }

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" none-ls needs plenery.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvimtools/none-ls.nvim'

" cspell is annoying because it doesn't integrate with the nvim dictionary, so i moved back to native spell.
" needs none-ls
" Plug 'davidmh/cspell.nvim'

" For vsnip users.
" Plug 'hrsh7th/cmp-vsnip'
" Plug 'hrsh7th/vim-vsnip'

" For luasnip users.
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'saadparwaiz1/cmp_luasnip'

" i use this.
" Plug 'ervandew/supertab'

" For ultisnips users.
" Plug 'SirVer/ultisnips'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" For snippy users.
" Plug 'dcampos/nvim-snippy'
" Plug 'dcampos/cmp-snippy'

" Plug 'sktaylor/vim-colors-solarized'

" Plug 'maxmx03/solarized.nvim'

