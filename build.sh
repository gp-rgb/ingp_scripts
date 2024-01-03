#!/bin/bash -l
conda init bash
source ~/.bashrc
conda create --name ingp_env python=3.7
eval "$(conda shell.bash hook)"
conda activate ingp_env

cd /home/ubuntu/georgia/
git clone --recursive https://github.com/nvlabs/instant-ngp
cd /home/ubuntu/georgia/instant-ngp/

#conda install -n base conda-libmamba-solver
#conda config --set solver libmamba

pip install cython decorator pyyaml matplotlib
pip install -r requirements.txt

conda install cmake=3.18 pytorch=1.12.1=py3.7_cuda11.6_cudnn8.3.2_0 torchvision=0.13.1=py37_cu116 torchaudio=0.12.1=py37_cu116 cudatoolkit=11.6 -c pytorch -c conda-forge
sudo apt-get install build-essential git python3-dev python3-pip libopenexr-dev libxi-dev libglfw3-dev libglew-dev libomp-dev libxinerama-dev libxcursor-dev
sudo apt-get install ffmpeg colmap
cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
#cmake . -B build -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc
cmake --build build --config RelWithDebInfo -j
