#!/bin/bash -l
conda init bash
source ~/.bashrc
conda create --name ingp_env8 python=3.8 
eval "$(conda shell.bash hook)"
conda activate ingp_env8
conda info
cd /home/ubuntu/georgia/
rm -r /home/ubuntu/georgia/instant-ngp/
git clone --recursive https://github.com/nvlabs/instant-ngp
cd /home/ubuntu/georgia/instant-ngp/

#conda install -n base conda-libmamba-solver
#conda config --set solver libmamba

#pip install cython decorator pyyaml matplotlib
pip install -r requirements.txt
#conda install --file requirements.txt

conda install cmake=3.22.2 nvidia
#conda install cmake=3.18 pytorch=2.1.2=py3.8_cuda12.1_cudnn8.9.2_0 torchvision=0.16.2=py38_cu121 torchaudio=2.1.2=py38_cu121 -c pytorch -c conda-forge
#conda install cmake=3.18 pytorch==2.1.1 torchvision==0.16.1 torchaudio==2.1.1 pytorch-cuda=12.1 -c pytorch -c nvidia
sudo apt-get install build-essential git python3-dev python3-pip libopenexr-dev libxi-dev libglfw3-dev libglew-dev libomp-dev libxinerama-dev libxcursor-dev
sudo apt-get install ffmpeg colmap

:'
if grep -q 'export PATH="/usr/local/cuda-12.2/bin:$PATH"' ~/.bashrc; then
    echo "Line is already present in ~/.bashrc"
else
    # 2. If not in ~/.bashrc, then add the line
    echo "Adding ''export PATH=''/usr/local/cuda-11.4/bin:$PATH'' to ~/.bashrc"
    echo 'export PATH="/usr/local/cuda-12.2/bin:$PATH"' >> ~/.bashrc
fi

# 1. Check if the line is in ~/.bashrc
if grep -q "export LD_LIBRARY_PATH=\"/usr/local/cuda-12.2/lib64:\$LD_LIBRARY_PATH\"" ~/.bashrc; then
    echo "Line is already present in ~/.bashrc"
else
    # 2. If not in ~/.bashrc, then add the line
    echo "Adding the line to ~/.bashrc"
    echo 'export LD_LIBRARY_PATH="/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc
fi
source ~/.bashrc
'

rm -r /home/ubuntu/georgia/instant-ngp/build/
cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DNGP_BUILD_WITH_GUI=off -DCMAKE_CUDA_ARCHITECTURES=86 -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc
cmake --build build --config RelWithDebInfo -j

