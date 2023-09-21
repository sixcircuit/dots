
# lazy load conda

load_conda() {
  unset -f conda > /dev/null 2>&1

   # >>> conda initialize >>>
   # !! Contents within this block are managed by 'conda init' !!
   __conda_setup="$('/Users/kendrick/.homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
   if [ $? -eq 0 ]; then
       eval "$__conda_setup"
   else
       if [ -f "/Users/kendrick/.homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
           . "/Users/kendrick/.homebrew/anaconda3/etc/profile.d/conda.sh"
       else
           export PATH="/Users/kendrick/.homebrew/anaconda3/bin:$PATH"
       fi
   fi
   unset __conda_setup
   # <<< conda initialize <<<
}

conda() {
  load_conda 
  conda $@
}
