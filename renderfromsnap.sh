#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"

conda activate ingp_env8
export QT_QPA_PLATFORM=offscreen

ngp_path=/home/ubuntu/georgia/instant-ngp
data_path=/home/ubuntu/georgia/data/chair
snap=checkpoint.ingp

while [[ $# -gt 0 ]]; do
    case "$1" in
        --ngp_path)
            ngp_path="$2"
            shift 2
            ;;
        --data_path)
            data_path="$2"
            shift 2
            ;;
        --snap)
            snap="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "ngp_path: $ngp_path"
echo "data_path: $data_path"

rm -r ${data_path}/screenshots/

cd ${ngp_path}

python3 ${ngp_path}/scripts/run.py \
    --load_snapshot ${data_path}/${snap} \
    --screenshot_transforms ${data_path}/transforms.json \
    --screenshot_dir ${data_path}/screenshots/ \
    --screenshot_spp 16 \
    --width 720 --height 1280 \
    --n_steps 0

# width and height 0 preserves blendernerf default


#${data_path} --save_mesh ${data_path}/${mesh_name} --marching_cubes_res ${mesh_resolution} --save_snapshot ${data_path}/${snapshot}
