#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"

conda activate ingp_env8
export QT_QPA_PLATFORM=offscreen

ngp_path=/home/ubuntu/georgia/instant-ngp
data_path=/home/ubuntu/georgia/data/statue
mesh_name=statue.obj
snap=checkpoint.ingp
mesh_resolution=64








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

echo "ngp_path: $ngp_path"
echo "data_path: $data_path"
echo "mesh_resolution: $mesh_resolution" 

cd ${data_path}
rm ${data_path}/transforms.json


python ${ngp_path}/scripts/record3d2nerf.py --scene ${data_path}

cd ${ngp_path}

python3 ${ngp_path}/scripts/run.py ${data_path} --save_mesh ${data_path}/${mesh_name} --marching_cubes_res ${mesh_resolution} --save_snapshot ${data_path}/${snap} 

