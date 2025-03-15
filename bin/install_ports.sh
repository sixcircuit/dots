version="2.10.5"
mkdir ${HOME}/macports_install
cd ${HOME}/macports_install
mv ~/Downloads/MacPorts-$version.tar.gz ./
tar -xzvf MacPorts-$version.tar.gz
cd MacPorts-$version
./configure --prefix=${HOME}/.macports --with-tclpackage=${HOME}/.macports/tcl \
--with-install-user=${USER} --with-install-group=staff
make
make install
