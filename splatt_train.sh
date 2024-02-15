#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate gaussian_splatting
SOURCE=orchid
DATASET=orchid_splatt

source_directory="/home/ubuntu/georgia/data/${SOURCE}/rgbd/"
destination_directory="/home/ubuntu/georgia/data/${DATASET}/input"
number_of_links=50

# Create destination directory if it doesn't exist
rm -r ${destination_directory}
mkdir -p "$destination_directory"

# Use find to locate all JPEG files in the source directory
find "$source_directory" -type f -name "*.jpg" -o -name "*.jpeg" | shuf -n "$number_of_links" | while IFS= read -r file; do
    # Create symbolic links in the destination directory
    ln -s "$file" "$destination_directory"
done
ls {$destination_directory}/

cd /home/ubuntu/georgia/splatt/gaussian-splatting/
start=$(date +%s.%N)
python convert.py \
        -s /home/ubuntu/georgia/data/${DATASET}/ \
        --colmap_executable /home/ubuntu/georgia/colmap/build/src/colmap/exe/colmap
dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Colmap Execution Time: %.6f seconds" $dur

for N in 32000 
do
        echo $N
        python train.py \
                --iterations ${N} \
                --eval \
                -s /home/ubuntu/georgia/data/${DATASET}/ \
                -m /home/ubuntu/georgia/data/${DATASET}/${DATASET}_model \
                --save_iterations ${N} 
        python render.py \
                --eval \
                -m /home/ubuntu/georgia/data/${DATASET}/${DATASET}_model

done
python train.py \
        --iterations 32000 \
        --eval \
        -s /home/ubuntu/georgia/data/${DATASET}/ \
        -m /home/ubuntu/georgia/data/${DATASET}/${DATASET}_model \
        --save_iterations 500 1000 2000 4000 8000 16000 32000 
python render.py \
        --eval \
        -m /home/ubuntu/georgia/data/${DATASET}/${DATASET}_model

cd /home/ubuntu/georgia/data/${DATASET}/
zip ${DATASET}_splatt.zip /home/ubuntu/georgia/data/${DATASET}/${DATASET}_model/  -r