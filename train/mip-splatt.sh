#!/bin/bash

cd /home/ubuntu/georgia/splatt/mip-splatting/
conda activate mip-splatting

python train.py -m /home/ubuntu/georgia/data/yard//splatt_model/ -s /home/ubuntu/georgia/data/yard/
python create_fused_ply.py -m /home/ubuntu/georgia/data/yard//splatt_model/ --output_ply fused/yard_fused.ply

