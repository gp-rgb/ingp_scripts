#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate ingp_env8

export QT_QPA_PLATFORM=offscreen

## PATH SETTINGS
ngp_path=/home/ubuntu/georgia/instant-ngp/
data_path=/home/ubuntu/georgia/data/

## VIDEO & IMAGE SETTINGS 
fps=2
aabb=2
sharpen=0

## TRAINING SETTINGS
overwrite=0
n_steps=4096

## PARSE ARGUMENTS
if [ $# -lt 2 ]; then
    echo "Usage: $(basename $0) [TYPE] [DATASET]..."
    exit 1
fi

type="$1"
dataset="$2"
shift 2

while getopts 'a:f:hn:os:' opt; do
  case "$opt" in
    a|aabb)
        aabb=${OPTARG}
        ;;

    f|fps)
        fps=${OPTARG}
        ;;

    n|n_steps)
        n_steps=${OPTARG}
        ;;
    o|overwrite)
        overwrite=1
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
      echo "    -f,--fps:        <frames per second>"
      echo "    -n,--n_steps:    <number of training steps>"
      echo "    -o,--overwrite   "
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
case ${type} in
    video)
        echo "Preparing VIDEO Data..."
        if [ "$overwrite" -eq 1 ] || ! [ -f "${data_path}/transforms.json" ]; then
            ## run colmap if: overwrite is set OR transforms do not yet exist
            rm ${source_path}/transforms.json
            python3 ${ngp_path}/scripts/colmap2nerf.py \
                --video_in ${dataset}.mp4 \
                --video_fps ${fps} \
                --run_colmap \
                --aabb_scale ${aabb} \
                --colmap_matcher sequential \
                --overwrite
        fi
        ;;
    record3d)
        echo "Preparing RECORD3D Data..."
        python ${ngp_path}/scripts/record3d2nerf.py --scene ${source_path}
        ;;
    images)
        echo "Preparing IMAGE Data..."
        cd ${source_path}
        if [ "$overwrite" -eq 1 ] || ! [ -f "${data_path}/transforms.json" ]; then
            ## run colmap if: overwrite is set OR transforms do not yet exist
            rm ${source_path}/transforms.json
            python3 ${ngp_path}/scripts/colmap2nerf.py \
                --colmap_matcher exhaustive \
                --run_colmap \
                --aabb_scale ${aabb} \
                --overwrite
        fi
        ;;
    blender)
        echo "Preparing BLENDER Data..."
        cd ${source_path}
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
python3 ${ngp_path}/scripts/run.py \
    ${source_path} \
    --save_snapshot ${data_path}/checkpoint.ingp \
    --n_steps ${n_steps}

