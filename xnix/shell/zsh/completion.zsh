
#Set the auto completion on
# old, slow way
# autoload -U compinit
# compinit

# for startup speed, only check zcompdump once a day

shell=$1
plat=$2

if [[ "$plat" == "macos" ]]; then
   autoload -Uz compinit
   if [[ ! -f ~/.zcompdump || $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]]; then
      # echo "reload compinit..."
      compinit
   else
     compinit -C
   fi
else
   echo "everything else"
   autoload -Uz compinit
   for dump in ~/.zcompdump(N.mh+24); do
      # echo "reload compinit..."
      compinit
   done
   compinit -C
fi

# setopt autolist
# unsetopt menucomplete
# setopt noautomenu
setopt noautomenu
setopt nomenucomplete


# COMPLETION 
# FOR SPEED
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# END FOR SPEED

# case insensitive completion -- if you don't like fuzzy
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# a bunch of fuzzy attempts
# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
# zstyle ':completion:*' matcher-list '' \
#   'm:{a-z\-}={A-Z\_}' \
#   'r:|?=** m:{a-z\-}={A-Z\_}'
#   'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}'
#   'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \

# fuzzy complete
# zstyle ':completion:*' matcher-list 'r:|?=** m:{a-z\-}={A-Z\_}'

# bindkey '^i' complete-word

# remove git completion
#compdef -d git

# Faster! (?)
#zstyle ':completion::complete:*' use-cache 1

# try some fuzzy shit.
# zstyle ':completion:*:*:*:*:globbed-files' matcher 'r:|?=** m:{a-z\-}={A-Z\_}'
# zstyle ':completion:*:*:*:*:local-directories' matcher 'r:|?=** m:{a-z\-}={A-Z\_}'
# zstyle ':completion:*:*:*:*:directories' matcher 'r:|?=** m:{a-z\-}={A-Z\_}'
# zstyle ':completion:*' menu select

# zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name ''
##zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete
#zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored

# generate descriptions with magic.
#zstyle ':completion:*' auto-description 'specify: %d'

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
# zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
#zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
# zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"
# zstyle ':completion:*:commands' list-colors '=*=1;31'

#unsetopt LIST_AMBIGUOUS
#setopt  COMPLETE_IN_WORD

# Separate man page sections.  Neat.
# zstyle ':completion:*:manuals' separate-sections true

# Egomaniac!
#zstyle ':completion:*' list-separator 'fREW'

# complete with a menu for xwindow ids
#zstyle ':completion:*:windows' menu on=0
#zstyle ':completion:*:expand:*' tag-order all-expansions

# more errors allowed for large words and fewer for small words
#zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

# Errors format
#zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

# Don't complete stuff already on the line
#zstyle ':completion::*:(rm|vi):*' ignore-line true

# Don't complete directory we are already in (../here)
#zstyle ':completion:*' ignore-parents parent pwd

#zstyle ':completion::approximate*:*' prefix-needed false

# COMPLETION END

