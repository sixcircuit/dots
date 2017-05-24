
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

if [[ $platform == 'linux' ]]; then
   alias ls='ls -h --color=auto'
elif [[ $platform == 'osx' ]]; then
   alias ls='ls -h -G'
fi

#Aliases
##ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias ll='ls -alhG'
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias rmr='rm -rf'
alias f='find'
alias rcp='rsync -ah --progress'
 
##cd, because typing the backslash is A LOT of work!!
alias pd='popd'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias sudo='sudo env PATH=$PATH'

function gr() {
    grep -r "$@" . 
}

www() {
    if [[ -z "$1" ]]; then
        open "http://localhost:8080" && python -m SimpleHTTPServer 8080 
    else
        open "http://localhost:${1}" && python -m SimpleHTTPServer $1
    fi
}
