
# Where it gets saved
export HISTFILE=~/.history

# Remember a lot of history
export SAVEHIST=20000
export HISTSIZE=20000
export HISTFILESIZE=20000

if [[ "$1" == "zsh" ]]; then
   setopt histignoredups
   echo ignore dupes!
elif [[ "$1" == "bash" ]]; then
   HISTCONTROL=$HISTCONTROL:ignoredups
   echo ignore dupes!
fi
