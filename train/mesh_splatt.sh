#!/bin/bash
eval "$(conda shell.bash hook)"
cd /home/ubuntu/georgia/splatt/gaussian-mesh-splatting
conda activate gaussian_splatting_mesh

DATA=/home/ubuntu/georgia/data/orchid_splatt/
MODEL=/home/ubuntu/georgia/data/orchid_splatt/orchid_splatt_model/

start=$(date +%s.%N)
python train.py --eval -s ${DATA} -m ${MODEL} --gs_type gs_mesh
dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Meshing Execution Time: %.6f seconds" $dur
