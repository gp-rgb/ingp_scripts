#!/bin/bash
cd /home/ubuntu/georgia/splatt
rm -r mip-splatting
git clone https://github.com/autonomousvision/mip-splatting.git --recursive
cd mip-splatting
conda init bash
source ~/.bashrc
conda env remove -n mip-splatting
conda create -y -n mip-splatting python=3.8
eval "$(conda shell.bash hook)"


conda activate mip-splatting

pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 -f https://download.pytorch.org/whl/torch_stable.html
conda install cudatoolkit-dev=11.3 -c conda-forge

pip install -r requirements.txt

pip install submodules/diff-gaussian-rasterization
pip install submodules/simple-knn/

