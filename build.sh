#!/bin/bash
cd /mnt/instance
git clone --recursive https://github.com/nvlabs/instant-ngp
cd /mnt/instance/instant-ngp/

conda deactivate
conda init bash
conda create --prefix=/mnt/instance/instant-ngp/envs python=3.7
conda activate /mnt/instance/instant-ngp/envs/

conda install -n base conda-libmamba-solver
conda config --set solver libmamba

pip install cython decorator pyyaml matplotlib
pip install -r requirements.txt

conda install cmake=3.18 pytorch=1.12.1=py3.7_cuda11.6_cudnn8.3.2_0 torchvision=0.13.1=py37_cu116 torchaudio=0.12.1=py37_cu116 cudatoolkit=11.6 -c pytorch -c conda-forge
sudo apt-get install build-essential git python3-dev python3-pip libopenexr-dev libxi-dev libglfw3-dev libglew-dev libomp-dev libxinerama-dev libxcursor-dev

#cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake . -B build -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc
cmake --build build --config RelWithDebInfo -j

cd /mnt/instance/instant-ngp/
