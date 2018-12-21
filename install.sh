#!/bin/bash
cd ~

mkdir ~/.ssh

ln -s ./shell/ackrc ./.ackrc
ln -s ./shell/bash_profile ./.bash_profile
ln -s ./shell/bashrc ./.bashrc
ln -s ./shell/bin ./bin

cp ./shell/gitconfig.example ./shell/gitconfig
ln -s ./shell/gitconfig ./.gitconfig

ln -s ./shell/gitignore ./.gitignore

cp ./shell/load_keys.example.sh ./shell/load_keys.sh
ln -s ./shell/load_keys.sh ./.load_keys.sh

ln -s ./shell/screenrc ./.screenrc
ln -s ./shell/tmux.conf ./.tmux.conf

cp ./shell/tux.example.js ./shell/tux.js
ln -s ./shell/tux.js ./.tux.js

ln -s ./shell/vimrc ./.vimrc
ln -s ./shell/zshrc ./.zshrc

mkdir ./.vim
cd ./.vim
ln -s ../shell/vim/* ./

