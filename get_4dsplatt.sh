#!/bin/bash

conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate gaussian_splatting

cd /home/ubuntu/georgia/splatt/
git clone https://github.com/hustvl/4DGaussians
cd /home/ubuntu/georgia/splatt/4DGaussians
git submodule update --init --recursive
conda create -n Gaussians4D python=3.7
conda activate Gaussians4D

pip install -r requirements.txt
pip install -e submodules/depth-diff-gaussian-rasterization
pip install -e submodules/simple-knn
