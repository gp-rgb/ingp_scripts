#!/bin/bash
rm -r /home/ubuntu/georgia/instant-ngp/build

cd /home/ubuntu/georgia/instant-ngp/
cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake -DNGP_BUILD_WITH_GUI=off
#cmake . -B build -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc
cmake --build build --config RelWithDebInfo -j
