#!/bin/bash

cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake  -S ./ -B Debug -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug
make -C Debug VERBOSE=1