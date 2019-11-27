# Setup fzf
# ---------
# if [[ ! "$PATH" == */Users/kendrick/shell/fzf/bin* ]]; then
  # export PATH="${PATH:+${PATH}:}/Users/kendrick/shell/fzf/bin"
# fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "~/software/_fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
# source "/Users/kendrick/shell/fzf/shell/key-bindings.zsh"

# don't wait for **, just complete on tab.
# export FZF_DEFAULT_OPTS='--bind tab:down --cycle'
