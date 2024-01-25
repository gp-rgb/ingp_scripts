#!/bin/bash

pip uninstall jax jaxlib

cd /home/ubuntu/georgia/
git clone --depth 1 -b v0.4.4 https://github.com/google/jax
#git clone https://github.com/google/jax

cd /home/ubuntu/georgia/jax/
#git reset --hard 58e46b4 #version 0.4.4

sudo apt install g++ python python3-dev
pip install numpy wheel build
python build/build.py --enable_cuda
pip install dist/*.whl


