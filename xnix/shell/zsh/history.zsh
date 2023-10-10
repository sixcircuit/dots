
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

