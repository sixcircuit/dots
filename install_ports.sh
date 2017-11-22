mkdir ${HOME}/macports_install
cd ${HOME}/macports_install
mv ~/Downloads/MacPorts-2.4.2.tar.gz ./
tar -xzvf MacPorts-2.4.2.tar.gz
cd MacPorts-2.4.2
./configure --prefix=${HOME}/.macports --with-tclpackage=${HOME}/.macports/tcl \
--with-install-user=${USER} --with-install-group=staff
make
make install
