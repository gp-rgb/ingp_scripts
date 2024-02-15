#!/bin/bash
cd ../
wget http://www.cmake.org/files/v2.8/cmake-2.8.3.tar.gz
tar xzf cmake-2.8.3.tar.gz
cd cmake-2.8.3
./configure --prefix=/opt/cmake

make
make install
/opt/cmake/bin/cmake -version
