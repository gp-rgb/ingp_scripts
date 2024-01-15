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

if [[$# <= 2]]; then
    echo "Usage: $(basename $0) [TYPE] [DATASET]..."
    exit 1
fi

type="$1"
dataset="$2"
shift 2

echo "DATATYPE IS:  ${type}"
echo "DATASET IS:   ${dataset}"


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
