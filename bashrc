
current_dir=`pwd`

cd ~/shell

source ./shell/common.sh

alias src="source ~/.bash_profile"

shopt -s histappend

set -o vi

if [ -f /.production ]; then
    export PS1="{bg_red}[\u@\h \w]$ "
else
    export PS1="[\u@\h \w]$ "
fi

cd "$current_dir"
