
# key bindings

# vim mode

bindkey -v

# fix for tmux, but fzf handles it now
# bindkey '^r' history-incremental-search-backward 

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

setopt ignoreeof
# ctrl-d() { zle -M "zsh: use 'exit' to exit."; return 1 } 
ctrl-d() { return 1 } 
zle -N ctrl-d
bindkey '^D' ctrl-d

zle     -N            fzf-cd-widget
bindkey -M emacs '^J' fzf-cd-widget
bindkey -M vicmd '^J' fzf-cd-widget
bindkey -M viins '^J' fzf-cd-widget

zle     -N            fzf-history-widget
bindkey -M emacs '^H' fzf-history-widget
bindkey -M vicmd '^H' fzf-history-widget
bindkey -M viins '^H' fzf-history-widget

zle     -N            fzf-file-widget
bindkey -M emacs '^K' fzf-file-widget
bindkey -M vicmd '^K' fzf-file-widget
bindkey -M viins '^K' fzf-file-widget
