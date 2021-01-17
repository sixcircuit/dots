
export PATH=~/bin:$PATH
export PATH=$PATH:~/software

# add all the directories in auto to path
for d in ~/software/auto_path/*; do PATH="$PATH:$d"; done

