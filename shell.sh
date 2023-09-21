
restore_working_dir=`pwd`

echo "source: ~/term/xnix/shell/plat.sh"
echo "args: $1"

shell=$1

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
   plat="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
   plat="macos"
else
   echo "UNKNOWN SYSTEM FOR SHELL DOTFILES: ~/term/shell.sh"
fi

# this sets the path for the $plat in the right spot
cd ~/term/xnix/shell
source ./plat.sh $shell $plat 

cd ~/term/$plat/shell
echo "source: ~/term/$plat/shell/plat.sh"
source ./plat.sh $shell $plat

cd "$restore_working_dir"

