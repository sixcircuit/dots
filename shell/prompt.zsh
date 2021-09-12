
SPACESHIP_PROMPT_ORDER=(
  # time          # Time stamps section
  # char          # Prompt character
  user          # Username section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exit_code     # Exit code section
  time          # Time stamps section
  dir           # Current directory section
  char          # Prompt character
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
)

SPACESHIP_RPROMPT_ORDER=( 
  # time 
  # exit_code     # Exit code section
)

local foreground=245
local darker=236
local darkest=238
local git_color=$darkest
local user_color=$darkest
local host_color=$darkest
local exit_code_color=$darkest

local gold=214 # gold
local red=196 # red
local green=40 # green
local orange=202 # orange
local purple=57 # purple
local dark_blue=21 # dark blue
local light_blue=33 # light blue

local char_color=$light_blue

# SPACESHIP_CHAR_COLORS=( $gold $red $green $orange $purple $dark_blue $light_blue )

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false

SPACESHIP_TIME_SHOW="true"
SPACESHIP_TIME_PREFIX="%F{$git_color}(%f" # the paren in there is what we print
SPACESHIP_TIME_SUFFIX="%F{$git_color}) %f" # the paren + space in there is what we print
SPACESHIP_TIME_COLOR=$git_color
SPACESHIP_TIME_FORMAT="%D{%Y-%m-%d} %D{%H:%M:%S}"

# TODO: turn these into times, and compare them you can't go past 
# https://unix.stackexchange.com/questions/84381/how-to-compare-two-dates-in-a-shell
# also, these only work crossing the midnight boundary like they do.
# with the two trigger hours gte 23 and the start hour gte 1
# which is fine for me, and i'm lazy.
# there might be something cute with subtraction and addition where you don't have to special case the different boundary conditions.
# but again, good enough for me, so I don't care.
SPACESHIP_TIME_TOO_LATE_DAY_START_HOUR=6
SPACESHIP_TIME_TOO_LATE_YELLOW_HOUR=22
SPACESHIP_TIME_TOO_LATE_RED_HOUR=23

SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

SPACESHIP_USER_SHOW="always"

SPACESHIP_USER_PREFIX=""
SPACESHIP_USER_SUFFIX=""
SPACESHIP_USER_COLOR=$user_color

SPACESHIP_HOST_SHOW="always"
SPACESHIP_HOST_PREFIX="%F{$host_color}@%f" # the @ in there is what we print
SPACESHIP_HOST_SUFFIX=" "
SPACESHIP_HOST_COLOR=$host_color

SPACESHIP_GIT_PREFIX="%F{$git_color}(%f" # the paren in there is what we print
SPACESHIP_GIT_SUFFIX="%F{$git_color}) %f" # the paren + space in there is what we print
SPACESHIP_GIT_SHOW="always"
SPACESHIP_GIT_NO_REPO_STRING="%F{$git_color}(---)%f "
SPACESHIP_GIT_SYMBOL=""
SPACESHIP_GIT_BRANCH_COLOR=$git_color
SPACESHIP_GIT_STATUS_SHOW=false

SPACESHIP_EXIT_CODE_SHOW="always"
SPACESHIP_EXIT_CODE_SYMBOL=""
SPACESHIP_EXIT_CODE_PREFIX="%F{$exit_code_color}(%f" # the paren in there is what we print
SPACESHIP_EXIT_CODE_SUFFIX="%F{$exit_code_color}) %f" # the paren + space in there is what we print
SPACESHIP_EXIT_CODE_COLOR_SUCCESS="$exit_code_color"
SPACESHIP_EXIT_CODE_COLOR_FAILURE="red"

SPACESHIP_CHAR_SYMBOL="∙"
SPACESHIP_CHAR_PREFIX="\n"
SPACESHIP_CHAR_SUFFIX=" "
# SPACESHIP_CHAR_SYMBOL_ROOT="#"
SPACESHIP_CHAR_COLOR_SUCCESS=$char_color
SPACESHIP_CHAR_COLOR_FAILURE=$char_color
SPACESHIP_CHAR_COLOR_SECONDARY=$char_color

SPACESHIP_DIR_PREFIX="\n%F{$foreground}[%f" # the paren in there is what we print
SPACESHIP_DIR_SUFFIX="%F{$foreground}]%f" # the paren + space in there is what we print
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO="false"
SPACESHIP_DIR_COLOR=$foreground 
SPACESHIP_DIR_LOCK_SYMBOL=""


# export SPACESHIP_ROOT=${${(%):-%x}:A:h}
SPACESHIP_ROOT="$HOME/shell/shell/spaceship-prompt"

fpath=( "$HOME/shell/shell/zsh_functions" $fpath )

autoload -U promptinit; promptinit
prompt spaceship

