
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

if [[ $platform == 'linux' ]]; then
   alias ls='ls -h --color=auto'
elif [[ $platform == 'osx' ]]; then
   alias ls='ls -hG'
fi

#Aliases
##ls, the common ones I use a lot shortened for rapid fire usage
alias la='ls -GA'   # no list, almost all
alias ll='ls -lA'   # list, almost all
alias lt='ls -lAt'   # list, almost all, sort by time
alias lr='ls -lAR'   # list, almost all, recursive

alias t='tree'

alias rmr='rm -rf'

alias rcp='rsync -ah --progress'
 
##cd, because typing the backslash is A LOT of work!!
alias pd='popd'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias sudo='sudo env PATH=$PATH'


alias gb='git branch -v'
alias gg='git checkout'
alias ga='git add'
alias gl='git lg'
alias gm='git merge'
alias gc='git commit'
alias gca='git commit -am'
alias gcm='git commit -m'
alias gd='git difftool'
alias gp='git push'
alias gs='git status'
