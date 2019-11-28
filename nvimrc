



" START NeoBundle Required

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.nvim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.nvim/bundle/'))

source ~/.xvix/bundle.vim

" NeoBundle 'Valloric/YouCompleteMe'

call neobundle#end()
NeoBundleCheck

let g:auto_session_root = $HOME . "/.nvim/sessions"

source ~/.xvix/main.vim
source ~/.nvim/config/main.vim


