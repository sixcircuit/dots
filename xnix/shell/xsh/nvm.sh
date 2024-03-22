shell=$1

export NVM_DIR=~/.nvm

load_nvm(){
   unset -f nvm node npm npx > /dev/null 2>&1
   [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
}

lazy_load_nvim(){

   # all props goes to http://broken-by.me/lazy-load-nvm/
   # grabbed from reddit @ https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/

   # Add every binary that requires nvm, npm or node to run to an array of node globals
   # adds npm, npx and any other binaries
   NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
   NODE_GLOBALS+=("node")
   NODE_GLOBALS+=("nvm")

   # Making node global trigger the lazy loading
   for cmd in "${NODE_GLOBALS[@]}"; do
      eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
   done
}

fast_load_nvm(){

   alias_path="$NVM_DIR/alias/default"

   if ! [ -f "$alias_path" ]; then
      echo "warning: error fast loading nvm. missing file: \"$alias_path\" you need to set \"nvm alias default <some_version>\". falling back to slow version."
      load_nvm;
      return
   fi

   alias_version=$(<$alias_path)

   if [ -z "$alias_version" ]; then
      echo "warning: error fast loading nvm. bad version: \"$alias_version\". you need to set \nvm alias default <some_version>\". falling back to slow version."
      load_nvm;
      return
   fi

   alias_version="v$alias_version"

   bin_path="$NVM_DIR/versions/node/$alias_version/bin"

   if ! [ -d "$bin_path" ]; then
      echo "warning: error fast loading nvm. missing directory (bin path): \"$bin_path\" you need to set \"nvm alias default <some_version>\". falling back to slow version."
      load_nvm;
      return
   fi

   export PATH="$bin_path":$PATH

   [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
}

# for bash, load direct, it doesn't seem to like the zsh code

if [[ "$shell" == "bash" ]]; then
   load_nvm;
else
   fast_load_nvm;
   # lazy_load_nvim;
fi

