
cd ./shell

ulimit -n 2000

# utility
# source ./colors.sh

source ./path.sh
source ./export.sh
source ./alias.sh

# these mess with the path, but only add themselves
source ./homebrew.sh
source ./macports.sh
source ./nvm.sh
source ./pyenv.sh
source ./ec2_api_tools.sh
source ./rvm.sh

source ./ssh_agent.sh

cd ..
