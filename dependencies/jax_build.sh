#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate merf
conda info

pip uninstall jax jaxlib

cd /home/ubuntu/georgia/
rm -r /home/ubuntu/georgia/jax/
git clone --depth 1 -b jaxlib-v0.4.4 https://github.com/google/jax

cd /home/ubuntu/georgia/jax/

sudo apt install g++ python python3-dev
pip install numpy wheel build
python build/build.py --enable_cuda --cuda_version 11.8 --cuda_path /usr/local/cuda/ --cudnn_path /opt/conda/envs/merf/ --cudnn_version 8

pip install dist/*.whl
pip install -e .

