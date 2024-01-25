#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda create --name merf python=3.9 pip;  conda activate merf

cd /home/ubuntu/georgia/google-data/
mkdir nerf_360  
cd /home/ubuntu/georgia/google-data/nerf_360
curl -O http://storage.googleapis.com/gresearch/refraw360/360_v2.zip
unzip 360_v2.zip

cd /home/ubuntu/georgia/google-research/merf/
#pip install -r requirements.txt

sudo apt install g++ python python3-dev
pip install numpy wheel build
python build/build.py --enable_cuda
pip install dist/*.whl

git clone https://github.com/rmbrualla/pycolmap.git ./internal/pycolmap

cd /home/ubuntu/georgia/google-research/merf/webviewer
mkdir -p third_party
curl https://unpkg.com/three@0.113.1/build/three.js --output third_party/three.js
curl https://unpkg.com/three@0.113.1/examples/js/controls/OrbitControls.js --output third_party/OrbitControls.js
curl https://unpkg.com/three@0.113.1/examples/js/controls/PointerLockControls.js --output third_party/PointerLockControls.js
curl https://unpkg.com/png-js@1.0.0/zlib.js --output third_party/zlib.js
curl https://unpkg.com/png-js@1.0.0/png.js --output third_party/png.js
curl https://unpkg.com/stats-js@1.0.1/build/stats.min.js --output third_party/stats.min.js
