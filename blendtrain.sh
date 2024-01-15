#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"

conda activate ingp_env8
export QT_QPA_PLATFORM=offscreen

ngp_path=/home/ubuntu/georgia/instant-ngp
data_path=/home/ubuntu/georgia/data/bunny
mesh_name=mesh.obj
snap=checkpoint.ingp
mesh_resolution=256
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
mkdir -p traindata testdata
mv train traindata
mv transforms_train.json traindata
mv transforms_test.json testdata


cd ${ngp_path}

python3 ${ngp_path}/scripts/run.py \
    --scene ${data_path}/traindata/ \
    --save_snapshot ${data_path}/${snap} \
    --screenshot_transforms ${data_path}/testdata/transforms_test.json \
    --screenshot_dir ${data_path}/test_data/ \
    --screenshot_spp 16 \
    --width 1920 \
    --height 1080
     --n_steps 8000

# width and height 0 preserves blendernerf default


#${data_path} --save_mesh ${data_path}/${mesh_name} --marching_cubes_res ${mesh_resolution} --save_snapshot ${data_path}/${snapshot}
