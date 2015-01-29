#!/usr/bin/env sh

set -ex

./autogen.sh
./configure CXXFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib
make clean
make -j8 && make install
