#!/bin/bash

conda activate ingp_env
cd /home/ubuntu/georgia/data
python /home/ubuntu/georgia/instant-ngp/scripts/colmap2nerf.py --video_in yard.mp4 --video_fps 4 --run_colmap --aabb_scale 32
#python /home/ubuntu/georgia/instant-ngp/scripts/run.py /home/ubuntu/georgia/data/ --save_mesh /home/georgia/data/mesh.obj --marching_cubes_res 256

