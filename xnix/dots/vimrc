source ~/.xvix/helpers.vim

" Python Setting {
  set pythondll=~/.pyenv/versions/3.9.0/bin/python
  set pythonhome=~/.pyenv/versions/3.9.0/
  set pythonthreedll=~/.pyenv/versions/3.9.0/bin/python
  set pythonthreehome=~/.pyenv/versions/3.9.0/
" }

" echo has('python3')
"
" set rubydll=~/.rvm/rubies/ruby-2.5.1/lib/libruby.2.5.dylib
" set rubydll=~/.rvm/rubies/ruby-2.6.3/lib/libruby.2.6.dylib
set rubydll=~/.homebrew/Cellar/ruby@2.6/2.6.9/lib/libruby.2.6.dylib

let g:auto_session_root = $HOME . "/.xvix_sessions"

call SourceDirectory("~/.xvix/baseline")

" START NeoBundle Required

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

source ~/.xvix/plugins.vim

NeoBundle 'sixcircuit/powerline', {'rtp': 'powerline/bindings/vim/'}
NeoBundle 'mkitt/tabline.vim'

" NeoBundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
" NeoBundle 'vim-powerline'
" NeoBundle 'Lokaltog/vim-powerline', { 'rev' : 'develop' }

call neobundle#end()
NeoBundleCheck

" don't know why but this needs to be here
source ~/.xvix/baseline/syntax.vim

call SourceDirectory("~/.xvix/functions")
call SourceDirectory("~/.xvix/plugins")
call SourceDirectory("~/.xvix/settings")

call SourceDirectory("~/.xvix/vim")

source ~/.xvix/keymaps.vim

" allow project specific settings -- needs to be at the end
source ~/.xvix/localrc.vim


