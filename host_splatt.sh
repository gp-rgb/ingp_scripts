#!/bin/bash
cd /home/ubuntu/georgia/splatt/
git clone https://github.com/antimatter15/splat.git
cd splat
pip install plyfile argparse  
pointcloud=/home/ubuntu/georgia/data/orchid_splatt/orchid_splatt_model/point_cloud/iteration_5000/point_cloud.ply

python convert.py ${pointcloud}
python /home/ubuntu/georgia/ingp_scripts/server_url.py 8000 ./output.splat
