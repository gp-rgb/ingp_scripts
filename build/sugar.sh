#!/bin/bash
# HTTPS
rm -r /home/ubuntu/georgia/splatt/SuGaR/
cd /home/ubuntu/georgia/splatt/
git clone https://github.com/Anttwo/SuGaR.git --recursive

cd ./SuGaR/
#conda env create -f environment.yml
eval "$(conda shell.bash hook)"

#conda activate sugar

conda create --name sugar -y python=3.9
conda activate sugar
conda install pytorch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 pytorch-cuda=11.8 -c pytorch -c nvidia
conda install -c fvcore -c iopath -c conda-forge fvcore iopath
conda install pytorch3d==0.7.4 -c pytorch3d
conda install -c plotly plotly
conda install -c conda-forge rich
conda install -c conda-forge plyfile==0.8.1
conda install -c conda-forge jupyterlab
conda install -c conda-forge nodejs
conda install -c conda-forge ipywidgets
pip install open3d
pip install --upgrade PyMCubes

cd gaussian_splatting/submodules/diff-gaussian-rasterization/
pip install -e .
cd ../simple-knn/
pip install -e .
cd ../../../

