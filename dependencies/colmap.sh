#!/bin/bash
cd /home/ubuntu/georgia

sudo apt-get install \
    git \
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev


# required for CUDA support:    
sudo apt-get install -y \
    nvidia-cuda-toolkit \
    nvidia-cuda-toolkit-gcc
export QT_QPA_PLATFORM=offscreen
source ~/.bashrc
git clone https://github.com/colmap/colmap.git
cd colmap
mkdir build
cd build
CC=/usr/bin/gcc-8 CXX=/usr/bin/g++-8 cmake .. -DCMAKE_CUDA_ARCHITECTURES=86 -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc
make -j
sudo make install

