# export LSCOLORS=dxfxcxdxbxegedabagacad
export LSCOLORS=""
export LS_COLORS=""

# LS_COLORS+="di=00;38;2;181;137;0:"
# LS_COLORS+="di=00;38;5;178:"
# LS_COLORS+="di=00;38;5;214:"
LS_COLORS+="di=00;38;5;136:"
LS_COLORS+="ln=target:"
LS_COLORS+="ex=00;38;5;160:"

# LS_COLORS+="di=33;0:"
# LS_COLORS+="ln=35;40:"
# LS_COLORS+="ln=00;38;5;37:"
# LS_COLORS+="so=32;0:"
# LS_COLORS+="pi=33;0:"
# LS_COLORS+="ex=31;0:"
# LS_COLORS+="bd=34;46:"
# LS_COLORS+="cd=34;43:"
# LS_COLORS+="su=0;41:"
# LS_COLORS+="sg=0;46:"
# LS_COLORS+="tw=0;42:"
# LS_COLORS+="ow=0;43:"

# NORMAL 00;38;5;244 # no color code at all
# #FILE 00 # regular file: use no color at all
# RESET 0 # reset to "normal" color
# DIR 00;38;5;33 # directory 01;34
# LINK 01;38;5;37 # symbolic link. (If you set this to 'target' instead of a
#  # numerical value, the color is as for the file pointed to.)
# MULTIHARDLINK 00 # regular file with more than one link
# FIFO 48;5;230;38;5;136;01 # pipe
# SOCK 48;5;230;38;5;136;01 # socket
# DOOR 48;5;230;38;5;136;01 # door
# BLK 48;5;230;38;5;244;01 # block device driver
# CHR 48;5;230;38;5;244;01 # character device driver
# ORPHAN 48;5;235;38;5;160 # symlink to nonexistent file, or non-stat'able file
# SETUID 48;5;160;38;5;230 # file that is setuid (u+s)
# SETGID 48;5;136;38;5;230 # file that is setgid (g+s)
# CAPABILITY 30;41 # file with capability
# STICKY_OTHER_WRITABLE 48;5;64;38;5;230 # dir that is sticky and other-writable (+t,o+w)
# OTHER_WRITABLE 48;5;235;38;5;33 # dir that is other-writable (o+w) and not sticky
# STICKY 48;5;33;38;5;230 # dir with the sticky bit set (+t) and not other-writable
# # This is for files with execute permission:
# EXEC 01;38;5;64

ls="ls"

if [[ $plat == 'macos' ]]; then
   ls="gls"
fi

ls="$ls -N -h --color=auto --time-style=long-iso"

# we don't really need --dereference because we color with ln:target

list_all="-lA"
group_dir="--group-directories-first"
dref="--dereference"


alias ls="$ls $dref $group_dir"
alias ll="$ls $dref -l $group_dir"
alias la="$ls $list_all $group_dir"
# alias lz="$ls $list_all $dref --sort=size -s1"
# alias lt="$ls $list_all $dref --sort=time"

# this is ugly but seems to work strips the first three columns
# TODO: swap the date and size columns
# TODO: add "B" to size column if there isn't a unit
sed_three_col_filter=" --color=always | sed -E 's/[\+drwxst-]{10,11}[[:space:]]+[[:digit:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+//'"

function lz(){ 
   eval "$ls $list_all $dref --sort=size -r $@ $sed_three_col_filter"
}

function lt(){ 
   eval "$ls $list_all $dref --sort=time -r $@ $sed_three_col_filter"
}
