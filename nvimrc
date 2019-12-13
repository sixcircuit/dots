source ~/.xvix/helpers.vim




let g:auto_session_root = $HOME . "/.xvix_sessions"

call SourceDirectory("~/.xvix/baseline")

" START NeoBundle Required

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.nvim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.nvim/bundle/'))

source ~/.xvix/plugins.vim


NeoBundle 'itchyny/lightline.vim'

" NeoBundle 'vim-airline/vim-airline'
" NeoBundle 'vim-airline/vim-airline-themes'

NeoBundle 'mkitt/tabline.vim'
"
" NeoBundle 'Shougo/deoplete.nvim'

call neobundle#end()
NeoBundleCheck

" don't know why but this needs to be here
source ~/.xvix/baseline/syntax.vim

call SourceDirectory("~/.xvix/functions")
call SourceDirectory("~/.xvix/plugins")
call SourceDirectory("~/.xvix/settings")

call SourceDirectory("~/.xvix/nvim")

source ~/.xvix/keymaps.vim

" allow project specific settings -- needs to be at the end
source ~/.xvix/localrc.vim


