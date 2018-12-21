
SPACESHIP_PROMPT_ORDER=(
  # time          # Time stamps section
  # char          # Prompt character
  user          # Username section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exit_code     # Exit code section
  dir           # Current directory section
  # hg            # Mercurial section (hg_branch  + hg_status)
  # package       # Package version
  # node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift         # Swift section
  # golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia         # Julia section
  # docker        # Docker section
  # aws           # Amazon Web Services section
  # venv          # virtualenv section
  # conda         # conda virtualenv section
  # pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember         # Ember.js section
  # kubecontext   # Kubectl context section
  # terraform     # Terraform workspace section
  # exec_time     # Execution time
  # line_sep      # Line break
  # battery       # Battery level and status
  # vi_mode       # Vi-mode indicator
  # jobs          # Background jobs indicator
  # char          # Prompt character
)

SPACESHIP_RPROMPT_ORDER=( 
  # time 
  # exit_code     # Exit code section
)

local foreground=245
local base_prompt=242
local darker=241
local highlight=214
# local char_color=$highlight

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false

SPACESHIP_TIME_SHOW="true"

SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

SPACESHIP_USER_SHOW="always"
SPACESHIP_USER_PREFIX="%F{$highlight}∙%f "
SPACESHIP_USER_SUFFIX=""
SPACESHIP_USER_COLOR=$darker

SPACESHIP_HOST_SHOW="always"
SPACESHIP_HOST_PREFIX="%F{$darker}@%f" # the @ in there is what we print
SPACESHIP_HOST_SUFFIX=" "
SPACESHIP_HOST_COLOR=$darker

SPACESHIP_DIR_PREFIX="\n%F{$foreground}[%f" # the paren in there is what we print
SPACESHIP_DIR_SUFFIX="%F{$foreground}] %f" # the paren + space in there is what we print
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO="false"
SPACESHIP_DIR_COLOR=$foreground 
SPACESHIP_DIR_LOCK_SYMBOL=""

SPACESHIP_GIT_PREFIX="%F{$base_prompt}(%f" # the paren in there is what we print
SPACESHIP_GIT_SUFFIX="%F{$base_prompt}) %f" # the paren + space in there is what we print
SPACESHIP_GIT_SYMBOL=""
SPACESHIP_GIT_BRANCH_COLOR=$base_prompt
SPACESHIP_GIT_STATUS_SHOW=false

SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXIT_CODE_SYMBOL=""
SPACESHIP_EXIT_CODE_PREFIX="%F{$base_prompt}(%f" # the paren in there is what we print
SPACESHIP_EXIT_CODE_SUFFIX="%F{$base_prompt}) %f" # the paren + space in there is what we print
SPACESHIP_EXIT_CODE_COLOR=$darker

# SPACESHIP_CHAR_SYMBOL="∙"
# SPACESHIP_CHAR_SUFFIX=" "
# SPACESHIP_CHAR_SYMBOL_ROOT="#"
# SPACESHIP_CHAR_COLOR_SUCCESS=$char_color
# SPACESHIP_CHAR_COLOR_FAILURE=$char_color
# SPACESHIP_CHAR_COLOR_SECONDARY=$char_color

fpath=( "$HOME/shell/shell/zsh_functions" $fpath )

autoload -U promptinit; promptinit
prompt spaceship

