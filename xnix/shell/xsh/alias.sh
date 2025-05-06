shell=$1
plat=$2

# alias s='source $HOME/.zshrc'
alias x='exit'
alias v='vim'
alias vd='vimdiff'
alias t='\tux'
alias tt='tree'
alias tux='echo "USE Ctrl+O to open sessions."'
alias ter='terraform'
alias kc='kubectl'
alias cpr='cp -R'

alias ta='tag_add'
alias tl="tag_ls"

small_llm="llama-3.1-8b"
big_llm="llama-3.3-70b"

alias lc="llm continue"
alias lls="llm $small_llm"
alias llb="llm $big_llm"
alias lsv="llm $small_llm verbose"
alias lbv="llm $big_llm verbose"
alias lsj="llm $small_llm jsfun"
alias lbj="llm $big_llm jsfun"

c() {
   local result=`dir_first_fuzzy "$@"`
   if [ $? -eq 0 ]; then
      # echo "cd $result"
      cd "$result"
   fi
}

alias rgl='rg -F'

alias ff='file_find'
alias fff='file_find_fuzzy'

alias wget='curl -L -O'

alias fs='fstats'

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
alias gl='git_log'
alias gm='git merge'
alias gc='git commit'
alias gca='git commit -am'
alias gcm='git commit -m'
alias gd='git difftool'
alias gp='git push'
alias gs='git status'
alias gco='git checkout'

# gco() {
#   local branches branch
#   branches=$(git branch --all | grep -v HEAD) &&
#   branch=$(echo "$branches" |
#            fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
#   git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
# }


ew() {
   local cmd=$1
   if ! command -v "$cmd" > /dev/null; then
      echo "error: '$cmd' not found"
      return 1
   fi

   local target=$(command -v "$cmd")
   if [[ "$target" = /* && -f "$target" ]]; then
      "$EDITOR" "$target"
   else
      which "$cmd"
   fi
}
