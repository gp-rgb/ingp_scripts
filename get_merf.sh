#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda create --name merf python=3.9 pip;  conda activate merf
conda install anaconda::cudnn 

#cd /home/ubuntu/georgia/google-data/
#mkdir nerf_360  
#cd /home/ubuntu/georgia/google-data/nerf_360
#curl -O http://storage.googleapis.com/gresearch/refraw360/360_v2.zip
#unzip 360_v2.zip

cd /home/ubuntu/georgia/google-research/merf/
git clone https://github.com/rmbrualla/pycolmap.git ./internal/pycolmap

cd /home/ubuntu/georgia/ingp_scripts/
pip install -r merf_requirements.txt
pip uninstall tensorflow
pip install tf-nightly[and-cuda]

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

cd /home/ubuntu/georgia/google-research/merf/webviewer
mkdir -p third_party
curl https://unpkg.com/three@0.113.1/build/three.js --output third_party/three.js
curl https://unpkg.com/three@0.113.1/examples/js/controls/OrbitControls.js --output third_party/OrbitControls.js
curl https://unpkg.com/three@0.113.1/examples/js/controls/PointerLockControls.js --output third_party/PointerLockControls.js
curl https://unpkg.com/png-js@1.0.0/zlib.js --output third_party/zlib.js
curl https://unpkg.com/png-js@1.0.0/png.js --output third_party/png.js
curl https://unpkg.com/stats-js@1.0.1/build/stats.min.js --output third_party/stats.min.js
