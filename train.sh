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

type="$2"
dataset="$3"
shift 3

echo "DATATYPE IS:  ${type}"
echo "DATASET IS:   ${dataset}"
echo "OPTSTRING IS: ${2} ${3}"

while getopts 'abc:h' opt; do
  case "$opt" in
    a)
      echo "Processing option 'a'"
      ;;

    b)
      echo "Processing option 'b'"
      ;;

    c)
      arg="$OPTARG"
      echo "Processing option 'c' with '${OPTARG}' argument"
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) [-a] [-b] [-c arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"