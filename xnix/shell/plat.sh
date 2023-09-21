
# echo "~/term/xnix/shell/plat.sh"
# echo "args: $1 $2"

shell=$1
plat=$2

ulimit -n 2000

cd ./xsh
for f in ./*; do echo "sourcing: $f"; source $f $shell $plat; done
cd ..

if [[ "$shell" == "zsh" ]]; then
   cd ./zsh
   for f in ./*; do echo "sourcing: $f"; source $f $shell $plat; done
   cd ..
elif [[ "$shell" == "bash" ]]; then
   cd ./bash
   for f in ./*; do echo "sourcing: $f"; source $f $shell $plat; done
   cd ..
else
   echo "UNKNOWN SHELL TYPE FOR DOTFILES: ~/term/xnix/plat.sh $1"
fi
