#!/bin/bash
cd /home/ubuntu/georgia/instant-ngp/
rm -r /home/ubuntu/georgia/instant-ngp/build/
cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DNGP_BUILD_WITH_GUI=off -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc
cmake --build build --config RelWithDebInfo -j
