#!/bin/bash

rm -rf Debug/

echo
echo "***Running***"
echo "cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake  -S ./ -B Debug -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug"
echo

cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake  -S ./ -B Debug -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug

echo
echo "***Running***"
echo "make -C Debug VERBOSE=1"
echo

cmake --build Debug