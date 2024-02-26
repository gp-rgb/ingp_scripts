#!/bin/bash
rm -r /home/ubuntu/georgia/splatt/gaussian-splatting
cd /home/ubuntu/georgia/splatt/
git clone https://github.com/graphdeco-inria/gaussian-splatting.git --recursive
cd /home/ubuntu/georgia/splatt/gaussian-splatting
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda env remove -n gaussian_splatting
conda env create --file environment.yml
conda activate gaussian_splatting
pip install opencv-python matplotlib drawilleplot
