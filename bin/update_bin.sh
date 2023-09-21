#!/bin/bash

# git subtree add  --prefix .vim/bundle/tpope-vim-surround https://bitbucket.org/vim-plugins-mirror/vim-surround.git master --squash
# git subtree pull --prefix .vim/bundle/tpope-vim-surround https://bitbucket.org/vim-plugins-mirror/vim-surround.git master --squash


git subtree add  --prefix bin/_runner git@github.com:sixcircuit/runner.git master --squash
git subtree add  --prefix bin/_summer git@github.com:sixcircuit/summer.git master --squash
git subtree add  --prefix bin/_sync git@github.com:sixcircuit/sync.git master --squash

git subtree pull  --prefix bin/_runner git@github.com:sixcircuit/runner.git master --squash
git subtree pull  --prefix bin/_summer git@github.com:sixcircuit/summer.git master --squash
git subtree pull  --prefix bin/_sync git@github.com:sixcircuit/sync.git master --squash
