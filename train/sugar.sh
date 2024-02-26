#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate sugar
DATA=/home/ubuntu/georgia/data/orchid_splatt/
MODEL=/home/ubuntu/georgia/data/orchid_splatt/orchid_splatt_model/

cd /home/ubuntu/georgia/splatt/SuGaR/
#python gaussian_splatting/train.py -s ${DATA} --iterations 7000 -m ${MODEL}

start=$(date +%s.%N)
python train.py -s ${DATA} -c ${MODEL} -r "sdf" --low_poly True --refinement_time "short"  
dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Meshing Execution Time: %.6f seconds" $dur

