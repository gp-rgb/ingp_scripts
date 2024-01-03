#!/bin/bash

ngp_path=/mnt/instance/instant-ngp
data_path=/mnt/instance/instant-ngp/data/nerf/fox
dest_path=/mnt/instance/instant-ngp/data/nerf/fox
scene_size=2
format=.obj
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
        --dest_path)
            dest_path="$2"
            shift 2
            ;;
        --scene_size)
            scene_size="$2"
            shift 2
            ;;
    	--format)
	    format="$2"
	    shift 2
	    ;;
	--mesh_resolution)
	    mesh_resolution="$2"
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
echo "dest_path: $dest_path"
echo "scene_size: $scene_size"
echo "format: $format"
echo "mesh_resolution: $mesh_resolution" 


cd ${data_path}
rm ${data_path}/transforms.json
python ${ngp_path}/scripts/colmap2nerf.py --colmap_matcher exhaustive --run_colmap --aabb_scale ${scene_size}
cd ${ngp_path}
python ${ngp_path}/scripts/run.py ${data_path} --save_mesh ${dest_path}/mesh.${format} --marching_cubes_res ${mesh_resolution}
