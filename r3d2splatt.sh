#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate nerfstudio

NAME=orchid_exr
DATA=/home/ubuntu/georgia/data/
DATAPATH="${DATA}/${NAME}"
STAMP=$(date +%s)
cd /home/ubuntu/georgia/splatt/nerfstudio_guassians/

#STAMP=1707282706
ns-process-data record3d --data ${DATAPATH} --output-dir ${DATAPATH} --max_dataset_size 300
ns-train gaussian-splatting --data ${DATAPATH} --output_dir ${DATAPATH} --timestamp ${STAMP} nerfstudio-data
ns-export gaussian-splat --load-config ${DATAPATH}/${NAME}/gaussian-splatting/${STAMP}/config.yml --output-dir ${DATAPATH}


ns-export poisson --load-config /home/ubuntu/georgia/data/orchid_exr/orchid_exr/gaussian-splatting/${STAMP}/config.yml --output-dir /home/ubuntu/georgia/data/orchid_exr/exports/mesh --target-num-faces 50000 --num-pixels-per-side 1024 --num-points 1000000 --remove-outliers True --normal-method open3d --use_bounding_box False --obb_center 0.0 0.0 0.0 --obb_rotation 0.0 0.0 0.0 --obb_scale 1.0 1.0 1.0

ns-export pointcloud --load-config /home/ubuntu/georgia/data/orchid_exr/orchid_exr/gaussian-splatting/${STAMP}/config.yml --output-dir /home/ubuntu/georgia/data/orchid_exr/exports/point_cloud --num-points 1000000 --remove-outliers True --normal-method open3d --use_bounding_box False --save-world-frame True --obb_center 0.0 0.0 0.0 --obb_rotation 0.0 0.0 0.0 --obb_scale 1.0 1.0 1.0
