#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"

conda activate ingp_env8
export QT_QPA_PLATFORM=offscreen

ngp_path=/home/ubuntu/georgia/instant-ngp
data_path=/home/ubuntu/georgia/data/chair
snap_name=checkpoint.ingp
mesh_name=chair.obj
mesh_resolution=256

while [[ $# -gt 0 ]]; do
    case "$1" in
        --data_path)
            data_path="$2"
            shift 2
            ;;
        --snap_name)
            snap_path="$2"
            shift 2
            ;;
	    --mesh_resolution)
	        mesh_resolution="$2"
	        shift 2
	        ;;
        --mesh_name)
            mesh_name="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

python3 ${ngp_path}/scripts/run.py --load_snapshot ${data_path}/${snap_name} --n_steps 0 --save_mesh ${data_path}/${mesh_name} --marching_cubes_res ${mesh_resolution}
