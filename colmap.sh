#!/bin/bash
cd /mnt/instance

sudo apt-get install -o=dir::cache=/mnt/instance/colmap_cache/\
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

git clone https://github.com/colmap/colmap.git
cd /mnt/instance/colmap
git checkout dev
mkdir build
cd build
cmake .. -GNinja
ninja
sudo ninja install

colmap -h
