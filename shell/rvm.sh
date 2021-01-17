
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# direct way
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# lazy load rvm

# load_rvm() {
#   unset -f rvm > /dev/null 2>&1
#   [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
#   # Load RVM into a shell session *as a function*
# }
#
# rvm() {
#   load_rvm 
#   rvm $@
# }
