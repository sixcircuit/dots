# zmodload zsh/zprof # profile startup time

current_dir=`pwd`

export PS1="[%n@%m %~] "

cd ~/shell
source ./shell/common.sh
source ./shell/clip.zsh

source ./shell/prompt.zsh

# source ./shell/fzf.zsh

# auto ls on cd
function chpwd() {
    emulate -L zsh
    ls
}

#Set the auto completion on
# old, slow way
# autoload -U compinit
# compinit

# for startup speed, only check zcompdump once a day
# i don't even know if we need this, because I don't think i use command completion
# but fuck it, it's not that slow
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# setopt autolist
# unsetopt menucomplete
# setopt noautomenu
setopt noautomenu
setopt nomenucomplete

# job control, if a bare name is used, fg the job
setopt auto_resume

#Set some ZSH styles
#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

# Case insensitive globbing
setopt NO_CASE_GLOB

# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# This makes cd=pushd
setopt AUTO_PUSHD

# No more annoying pushd messages...
# setopt PUSHD_SILENT

# blank pushd goes to home
setopt PUSHD_TO_HOME

# this will ignore multiple directories for the stack.  Useful?  I dunno.
setopt PUSHD_IGNORE_DUPS

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
#setopt RM_STAR_WAIT

# COMPLETION 
#
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
  # 'm:{a-z\-}={A-Z\_}' \
  # 'r:|?=** m:{a-z\-}={A-Z\_}'
  # 'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}'
  # 'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \

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
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
#zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
#zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
# zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

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


# key bindings

# vim mode

bindkey -v

bindkey '^r' history-incremental-search-backward

# Search based on what you typed in already (same thing as ^r)
# bindkey -M vicmd "/" history-incremental-search-backward
# bindkey -M vicmd "?" history-incremental-search-forward
# bindkey -M vicmd "//" history-beginning-search-backward
# bindkey -M vicmd "??" history-beginning-search-forward

# bindkey "\eOP" run-help

# oh wow!  This is killer...  try it!
# bindkey -M vicmd "q" push-line

# Ensure that arrow keys work as they should
# bindkey '\e[A' up-line-or-history
# bindkey '\e[B' down-line-or-history

# bindkey '\eOA' up-line-or-history
# bindkey '\eOB' down-line-or-history

# bindkey '\e[C' forward-char
# bindkey '\e[D' backward-char

# bindkey '\eOC' forward-char
# bindkey '\eOD' backward-char

# bindkey -M viins 'jj' vi-cmd-mode
bindkey -M vicmd 'u' undo

bindkey -M viins '\C-l' clear-screen

# Rebind the insert key.  I really can't stand what it currently does.
# bindkey '\e[2~' overwrite-mode

# Rebind the delete key. Again, useless.
bindkey '\e[3~' delete-char

# Who doesn't want home and end to work?
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line


# bindkey -M vicmd '!' edit-command-output

# it's like, space AND completion.  Gnarlbot.
# bindkey -M viins ' ' magic-space


# history stuff

setopt INC_APPEND_HISTORY_TIME

# Killer: share history between multiple shells, appends history immediately
# setopt SHARE_HISTORY

# If I type cd and then cd again, only save the last one
# setopt HIST_IGNORE_DUPS

# Even if there are commands inbetween commands that are the same, still only save the last one
# setopt HIST_IGNORE_ALL_DUPS

# Pretty    Obvious.  Right?
setopt HIST_REDUCE_BLANKS

# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

#}}}

# prompt

# host_color=cyan
# history_color=yellow
# user_color=green
# root_color=red
# directory_color=magenta
# error_color=red
# jobs_color=green
#
# host_prompt="%{$fg_bold[$host_color]%}%m%{$reset_color%}"
#
# jobs_prompt1="%{$fg_bold[$jobs_color]%}(%{$reset_color%}"
#
# jobs_prompt2="%{$fg[$jobs_color]%}%j%{$reset_color%}"
#
# jobs_prompt3="%{$fg_bold[$jobs_color]%})%{$reset_color%}"
#
# jobs_total="%(1j.${jobs_prompt1}${jobs_prompt2}${jobs_prompt3} .)"
#
# history_prompt1="%{$fg_bold[$history_color]%}[%{$reset_color%}"
#
# history_prompt2="%{$fg[$history_color]%}%h%{$reset_color%}"
#
# history_prompt3="%{$fg_bold[$history_color]%}]%{$reset_color%}"
#
# history_total="${history_prompt1}${history_prompt2}${history_prompt3}"
#
# error_prompt1="%{$fg_bold[$error_color]%}<%{$reset_color%}"
#
# error_prompt2="%{$fg[$error_color]%}%?%{$reset_color%}"
#
# error_prompt3="%{$fg_bold[$error_color]%}>%{$reset_color%}"
#
# error_total="%(?..${error_prompt1}${error_prompt2}${error_prompt3} )"
#
# case "$TERM" in
#   (screen)
#     function precmd() { print -Pn "\033]0;S $TTY:t{%100<...<%~%<<}\007" }
#   ;;
#   (xterm)
#     directory_prompt=""
#   ;;
#   (*)
#     directory_prompt="%{$fg[$directory_color]%}%~%{$reset_color%} "
#   ;;
# esac
#
# if [[ $USER == root ]]; then
#     post_prompt="%{$fg_bold[$root_color]%}%#%{$reset_color%}"
# else
#     post_prompt="%{$fg_bold[$user_color]%}%#%{$reset_color%}"
# fi
#
#
# _force_rehash() {
#   (( CURRENT == 1 )) && rehash
#     return 1  # Because we didn't really complete anything
# }
#

setopt ignoreeof
# ctrl-d() { zle -M "zsh: use 'exit' to exit."; return 1 } 
ctrl-d() { return 1 } 
zle -N ctrl-d
bindkey '^D' ctrl-d

cd "$current_dir"

# zprof # profile startup time
