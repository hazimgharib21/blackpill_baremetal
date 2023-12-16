#!/bin/bash

cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake  -S ./ -B Release -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
make -C Release VERBOSE=1