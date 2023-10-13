
shell=$1
plat=$2

shell_root=`dirname $PWD`
xnix_root=`dirname $shell_root`
term_root=`dirname $xnix_root`

# echo "shell: $shell"
# echo "plat: $plat"
# echo "PWD: $PWD"
# echo "shell_root: $shell_root"
# echo "xnix_root: $xnix_root"
# echo "term_root: $term_root"
# add all the directories in bin paths to path

add_paths () {
   if [ "$shell" = "zsh" ]; then setopt no_nomatch; fi
   export PATH="$PATH:$1"
   for dir in $1/*; do 
      if [ -d $dir ]; then
         export PATH="$PATH:$dir";
      fi
   done
   if [ "$shell" = "zsh" ]; then setopt nomatch; fi
}

# this one is redundant.
# add_paths "$HOME/bin"

add_paths "$HOME/plat/bin"
add_paths "$term_root/$plat/bin"
add_paths "$xnix_root/bin"
add_paths "$term_root/local/bin"

