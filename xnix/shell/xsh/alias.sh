shell=$1
plat=$2

alias x='exit'
alias t='tree'
alias v='vim'
alias vd='vimdiff'

alias rmr='rm -rf'

alias rcp='rsync -ah --progress'
 
## cd, because typing the backslash is A LOT of work!!
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias sudo='sudo env PATH=$PATH'

alias vi="/usr/bin/vim"
alias vim="nvim"
alias vimdiff="nvim -d"

alias gb='git branch'
alias gbl='git branch -v'
alias gbd='git branch -d'
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

gco() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

