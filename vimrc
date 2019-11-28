
" set rubydll=~/.rvm/rubies/ruby-2.5.1/lib/libruby.2.5.dylib
set rubydll=~/.rvm/rubies/ruby-2.6.3/lib/libruby.2.6.dylib

" START NeoBundle Required

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

source ~/.xvix/bundle.vim

NeoBundle 'Valloric/YouCompleteMe'

call neobundle#end()
NeoBundleCheck

let g:auto_session_root = $HOME . "/.vim/sessions"

source ~/.xvix/main.vim
source ~/.vim/config/main.vim
