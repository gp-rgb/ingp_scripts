#!/bin/bash
rm -r /mnt/instance/instant-ngp/build

cd /mnt/instance/instant-ngp/

cmake . -B build -DCMAKE_CUDA_COMPILER=/usr/bin/nvcc
cmake --build build --config RelWithDebInfo -j
