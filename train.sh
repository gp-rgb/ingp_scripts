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
render=0
mesh=0

## PARSE ARGUMENTS
if [ $# -lt 2 ]; then
    echo "Usage: $(basename $0) [TYPE] [DATASET]..."
    exit 1
fi

type="$1"
dataset="$2"
shift 2

while getopts 'a:f:hn:m:ors:' opt; do
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
      echo "    -f,--fps:        <frames per second>"
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

case ${type} in
    video)
        echo "Preparing VIDEO Data..."
        if [ "$overwrite" -eq 1 ] || ! [ -f "${source_path}/transforms.json" ]; then
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
        mv ${dataset}.r3d ${dataset}.zip
        unzip ${dataset}.zip
        echo "Preparing RECORD3D Data..."
        python ${ngp_path}/scripts/record3d2nerf.py --scene ${source_path} --subsample 5
        ;;
    images)
        echo "Preparing IMAGE Data..."
        if [ "$overwrite" -eq 1 ] || ! [ -f "${source_path}/transforms.json" ]; then
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
    --save_snapshot ${source_path}/checkpoint.ingp \
    --n_steps ${n_steps}

## GENERATE OUTPUTS
if [ "$render" -eq 1 ]; then
    python3 ${ngp_path}/scripts/run.py \
        --load_snapshot ${source_path}/checkpoint.ingp \
        --screenshot_transforms ${source_path}/transforms.json \
        --screenshot_dir ${source_path}/renders/ \
        --screenshot_spp 16 \
        --width 720 --height 1280 \
        --n_steps 0
    zip renders.zip ${source_path}/renders/ -r
    
fi

if ! [ "$mesh" -eq 0 ]; then
    python3 ${ngp_path}/scripts/run.py \
        --load_snapshot ${data_path}/checkpoint.ingp \
        --save_mesh ${source_path}/${dataset}.obj \
        --marching_cubes_res ${mesh} \
        --n_steps 0
    zip ${dataset}.zip ${dataset}.obj
fi

