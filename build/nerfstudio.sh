#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda create --name nerfstudio -y python=3.8
conda activate nerfstudio
pip install --upgrade pip

pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 --extra-index-url https://download.pytorch.org/whl/cu118

conda install -c "nvidia/label/cuda-11.8.0" cuda-toolkit
pip install ninja git+https://github.com/NVlabs/tiny-cuda-nn/#subdirectory=bindings/torch

cd /home/ubuntu/georgia/splatt/
#git clone https://github.com/nerfstudio-project/nerfstudio.git
git clone https://github.com/jonstephens85/nerfstudio_guassians
cd /home/ubuntu/georgia/splatt/nerfstudio_guassians
pip install --upgrade pip setuptools
pip install -e .
