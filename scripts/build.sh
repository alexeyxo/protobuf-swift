#!/bin/sh
make clean;
./autogen.sh && \
./configure CXXFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib && \
make -j8 && make install;
