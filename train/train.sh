#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate ngp

export QT_QPA_PLATFORM=offscreen

## PATH SETTINGS
ngp_path=/home/ubuntu/georgia/instant-ngp/
data_path=/home/ubuntu/georgia/data/

## RECORD3D SETTINGS
decimate=1

## VIDEO & IMAGE SETTINGS 
fps=2
aabb=4
sharpen=0

## TRAINING SETTINGS
overwrite=0
n_steps=4096
render=0
mesh=0
load_only=0

## PARSE ARGUMENTS
if [ $# -lt 2 ]; then
    echo "Usage: $(basename $0) [TYPE] [DATASET]..."
    exit 1
fi

datatype="$1"
dataset="$2"
shift 2

while getopts 'a:d:f:hln:m:ors:' opt; do
  case "$opt" in
    a|aabb)
        aabb=${OPTARG}
        ;;
    d|decimate)
        decimate=${OPTARG}
        ;;
    f|fps)
        fps=${OPTARG}
        ;;
    l|load_only)
        load_only=1
        ;;
    n|n_steps)
        n_steps=${OPTARG}
        ;;
    m|mesh)
        mesh=${OPTARG}
        ;;
    o|overwrite)
        overwrite=1
        ;;
    r|render)
        render=1
        ;;
    s|sharpen)
        sharpen=${OPTARG}
        ;;
    ?|h)
      echo "Usage: $(basename $0) [TYPE] [DATASET]..."
      echo "    TYPE: video, record3d, images, blender"
      echo "    DATASET: chair, plant, statue, etc."
      echo "    Optional Arguments:"
      echo "    -a,--aabb:       <scene size>"
      echo "    -d.--decimate:   <frame subsample rate, record3d>"
      echo "    -f,--fps:        <frames per second>"
      echo "    -l,--load_only   "
      echo "    -n,--n_steps:    <number of training steps>"
      echo "    -m,--mesh:        <mesh resolution (64, 128, 256, 512)>"
      echo "    -o,--overwrite   "
      echo "    -r,--render   "
      echo "    -s,--sharpen:    <how much to sharpen each frame, 0 to 1.0>"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

source_path=${data_path}/${dataset}

echo "DATA TYPE is:     ${type}"
echo "DATASET is:       ${dataset}"
echo "SOURCE PATH is:   ${source_path}"

## PREPARE DATA
cd ${source_path}

case ${datatype} in
    video)
        if [ "$overwrite" -eq 1 ] || ! [ -f "${source_path}/transforms.json" ]; then
            ## run colmap if: overwrite is set OR transforms do not yet exist
            rm -r ${source_path}/images/ 
            start=$(date +%s.%N)
            python3 ${ngp_path}/scripts/colmap2nerf.py \
                --video_in ${dataset}.mp4 \
                --video_fps ${fps} \
                --run_colmap \
                --aabb_scale ${aabb} \
                --colmap_matcher sequential \
                --overwrite
            dur=$(echo "$(date +%s.%N) - $start" | bc)
            printf "Colmap Execution Time: %.6f seconds" $dur
        fi
        ;;
    record3d)
        if [ "$overwrite" -eq 1 ] || ! [ -f "${source_path}/transforms.json" ]; then
                mv ${dataset}.r3d ${dataset}.zip
                unzip ${dataset}.zip
                python ${ngp_path}/scripts/record3d2nerf.py --scene ${source_path} --subsample ${decimate}
        fi
        ;;
    images)
        if [ "$overwrite" -eq 1 ] || ! [ -f "${source_path}/transforms.json" ]; then
            ## run colmap if: overwrite is set OR transforms do not yet exist
            rm ${source_path}/transforms.json
            start=$(date +%s.%N)
            python3 ${ngp_path}/scripts/colmap2nerf.py \
                --colmap_matcher exhaustive \
                --run_colmap \
                --aabb_scale ${aabb} \
                --overwrite
            dur=$(echo "$(date +%s.%N) - $start" | bc)
            printf "Colmap Execution Time: %.6f seconds" $dur
        fi
        ;;
    blender)
        mkdir -p traindata testdata
        mv train traindata
        mv transforms_train.json traindata
        mv transforms_test.json testdata
        ;;
    *)
        echo "Usage: $(basename $0) [TYPE] [DATASET]..."
        echo "TYPE must be one of: video, record3d, images, blender"
        exit 1
        ;;
esac

## TRAIN MODEL
cd ${ngp_path}

if [ ${load_only} -eq 0 ]; then
    python3 ${ngp_path}/scripts/run.py \
        ${source_path} \
        --save_snapshot ${source_path}/checkpoint.ingp \
        --n_steps ${n_steps}
fi

## GENERATE OUTPUTS
if [ "$render" -eq 1 ]; then
    rm -r ${source_path}/${dataset}_renders/
    mkdir ${source_path}/${dataset}_renders/
    
    python3 ${ngp_path}/scripts/run.py \
        --load_snapshot ${source_path}/checkpoint.ingp \
        --screenshot_transforms ${source_path}/transforms.json \
        --screenshot_frames 1 10 20 30 40 50 60 70 80 90 100 \
        --screenshot_dir ${source_path}/${dataset}_renders/ \
        --screenshot_spp 2 \
        --width 1420 --height 1892 \
        --n_steps 0
        #--screenshot_transforms ${source_path}/transforms.json \
        #--screenshot_transforms ${data_path}/bunny/traindata/transforms_train.json \ 
    cd ${source_path}
    zip ${dataset}_renders_${n_steps}.zip ./${dataset}_renders/ -r
    echo "Renders saved to: ${dataset}_renders.zip"    
fi

if ! [ "$mesh" -eq 0 ]; then
    python3 ${ngp_path}/scripts/run.py \
        --load_snapshot ${source_path}/checkpoint.ingp \
        --save_mesh ${source_path}/${dataset}_${mesh}.obj \
        --marching_cubes_res ${mesh} \
        --n_steps 0
    cd ${source_path}
    zip ${dataset}_mesh.zip ${dataset}.obj
    echo "Mesh saved to: ${dataset}_mesh.zip"
fi

