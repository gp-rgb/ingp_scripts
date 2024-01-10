#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"

conda activate ingp_env8
export QT_QPA_PLATFORM=offscreen

ngp_path=/home/ubuntu/georgia/instant-ngp
data_path=/home/ubuntu/georgia/data/chair
video_name=chair.mp4
mesh_name=chair.obj
snap=checkpoint.ingp
video=0
scene_size=2
mesh_resolution=256
fps=10
sharpen=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --sharpen)
            sharpen="$2"
            shift 2
            ;;
        --fps)
            fps="$2"
            shift 2
            ;;
        --ngp_path)
            ngp_path="$2"
            shift 2
            ;;
        --data_path)
            data_path="$2"
            shift 2
            ;;
        --dest_path)
            dest_path="$2"
            shift 2
            ;;
        --scene_size)
            scene_size="$2"
            shift 2
            ;;
	    --mesh_resolution)
	        mesh_resolution="$2"
	        shift 2
	        ;;
        --video_name)
            video_name="$2"
            video=1
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
echo "scene_size: $scene_size"
echo "format: $format"
echo "mesh_resolution: $mesh_resolution" 

cd ${data_path}
rm ${data_path}/transforms.json

#python /home/ubuntu/georgia/instant-ngp/scripts/run.py /home/ubuntu/georgia/data/ --save_mesh /home/ubuntu/georgia/data/mesh.obj --marching_cubes_res 256

if ((video == 1))
    then # INPUT IS VIDEO
        python3 ${ngp_path}/scripts/colmap2nerf.py --video_in ${video_name} --video_fps ${fps} --run_colmap --aabb_scale ${scene_size} --colmap_matcher sequential --overwrite
    else # INPUT IS IMAGE DATASET
        python3 ${ngp_path}/scripts/colmap2nerf.py --colmap_matcher exhaustive --run_colmap --aabb_scale ${scene_size} --overwrite
fi

cd ${ngp_path}
if ((load_snap == 0))
    then
        python3 ${ngp_path}/scripts/run.py ${data_path} --save_mesh ${data_path}/${mesh_name} --marching_cubes_res ${mesh_resolution} --sharpen ${sharpen} --save_snapshot ${data_path}/${snapshot}
    else
        python3 ${ngp_path}/scripts/run.py ${data_path} --save_mesh ${data_path}/${mesh_name} --marching_cubes_res ${mesh_resolution} --    sharpen ${sharpen} --save_snapshot ${data_path}/${snapshot} 

