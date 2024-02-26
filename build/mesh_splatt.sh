#!/bin/bash
eval "$(conda shell.bash hook)"
cd /home/ubuntu/georgia/splatt/
# HTTPS
git clone https://github.com/waczjoan/gaussian-mesh-splatting.git --recursive
cd ./gaussian-mesh-splatting
conda env create --file environment.yml
conda gaussian_splatting_mesh

