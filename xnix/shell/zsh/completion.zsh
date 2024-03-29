
shell=$1
plat=$2

# the "slow" way? this was slow but now it's not.
# don't know what the deal is.
autoload -Uz compinit
compinit

# https://github.com/Aloxaf/fzf-tab/wiki/Configuration

if [[ -f $HOME/plat/fzf-tab/fzf-tab.plugin.zsh ]]; then
   source $HOME/plat/fzf-tab/fzf-tab.plugin.zsh
else
   echo "missing $HOME/plat/fzf-tab/fzf-tab.plugin.zsh you should clone fzf-tab into ~/plat/fzf-tab from here: https://github.com/Aloxaf/fzf-tab"
fi


# for startup speed, only check zcompdump once a day, this seems unnecessary now.
# if [[ "$plat" == "macos" ]]; then
#    autoload -Uz compinit
#    if [[ ! -f ~/.zcompdump || $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]]; then
#       # echo "reloading compinit. (you should only see this once per day)"
#       compinit
#    else
#      compinit -C
#    fi
# else
#    autoload -Uz compinit
#    for dump in ~/.zcompdump(N.mh+24); do
#       # echo "reloading compinit. (you should only see this once per day)"
#       # compdump
#       compinit
#    done
#    compinit -C
# fi

# setopt autolist
# unsetopt menucomplete
# setopt noautomenu
setopt noautomenu
setopt nomenucomplete

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'find $realpath -type d -maxdepth 1'

# Allowlist:
# zstyle ':fzf-tab:*' disabled-on any
# zstyle ':fzf-tab:complete:<command in allowlist>:*' disabled-on none

# Denylist:
# zstyle ':fzf-tab:complete:<command in denylist>:*' disabled-on any
# Default value: zstyle ':fzf-tab:*' disabled-on none

# zstyle ':fzf-tab:complete:cd:*' disabled-on any
zstyle ':fzf-tab:complete:cd:*' accept-line enter
# zstyle ':fzf-tab:complete:tux:*' accept-line enter
# zstyle ':fzf-tab:*' accept-line enter


# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'


# COMPLETION
# FOR SPEED
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# END FOR SPEED

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

_tux_completion() {
   local -a subcommands
   local curcontext="$curcontext" state line
   typeset -A opt_args

   subcommands=("${(@f)$(tux compinit)}")

   # Determine the current state based on the words typed so far
   _arguments -C \
       '1: :->command' \
       '*:: :->args'

   case $state in
   command)
       _describe 'command' subcommands
       ;;
   args)
       case $line[1] in
       add)
           # Enable file completion for `tux add <file_path>`
           _files
           ;;
       *)
           # Handle other subcommands or default behavior
           ;;
       esac
       ;;
   esac
}

compdef _tux_completion tux

#Set some ZSH styles
#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# case insensitive completion -- if you don't like fuzzy
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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


# _force_rehash() {
#   (( CURRENT == 1 )) && rehash
#     return 1  # Because we didn't really complete anything
# }

# zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name ''
##zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete
#zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored

# generate descriptions with magic.
#zstyle ':completion:*' auto-description 'specify: %d'


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

