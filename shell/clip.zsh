
# I ripped this off from oh-my-zsh

# System clipboard integration
#
# This file has support for doing system clipboard copy and paste operations
# from the command line in a generic cross-platform fashion.
#
# On OS X and Windows, the main system clipboard or "pasteboard" is used. On other
# Unix-like OSes, this considers the X Windows CLIPBOARD selection to be the
# "system clipboard", and the X Windows `xclip` command must be installed.

# clip - Copy data to clipboard
#
# Usage:
#
#  <command> | clip    - copies stdin to clipboard
#
#  clip <file>         - copies a file's contents to clipboard
#
function clip() {
  emulate -L zsh
  local file=$1
  if [[ $OSTYPE == darwin* ]]; then
    if [[ -z $file ]]; then
      pbcopy
    else
      cat $file | pbcopy
    fi
  elif [[ $OSTYPE == cygwin* ]]; then
    if [[ -z $file ]]; then
      cat > /dev/clipboard
    else
      cat $file > /dev/clipboard
    fi
  else
    if (( $+commands[xclip] )); then
      if [[ -z $file ]]; then
        xclip -in -selection clipboard
      else
        xclip -in -selection clipboard $file
      fi
    elif (( $+commands[xsel] )); then
      if [[ -z $file ]]; then
        xsel --clipboard --input 
      else
        cat "$file" | xsel --clipboard --input
      fi
    else
      print "clip: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
      return 1
    fi
  fi
}

# clipp - "Paste" data from clipboard to stdout
#
# Usage:
#
#   clipp   - writes clipboard's contents to stdout
#
#   clipp | <command>    - pastes contents and pipes it to another process
#
#   clipp > <file>      - paste contents to a file
#
# Examples:
#
#   # Pipe to another process
#   clipp | grep foo
#
#   # Paste to a file
#   clipp > file.txt
function clipp() {
  emulate -L zsh
  if [[ $OSTYPE == darwin* ]]; then
    pbpaste
  elif [[ $OSTYPE == cygwin* ]]; then
    cat /dev/clipboard
  else
    if (( $+commands[xclip] )); then
      xclip -out -selection clipboard
    elif (( $+commands[xsel] )); then
      xsel --clipboard --output
    else
      print "clip: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
      return 1
    fi
  fi
}
