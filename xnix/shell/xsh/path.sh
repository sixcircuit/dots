
shell=$1
plat=$2

echo "shell: $shell"
echo "plat: $plat"

xnix_root=`dirname $PWD`
term_root=`dirname $xnix_root`

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

