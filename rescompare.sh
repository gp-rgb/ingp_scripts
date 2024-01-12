./snap2mesh.sh --data_path /home/ubuntu/georgia/data/chairrwo --snap_name checkpoint.ingp --mesh_resolution 64 --mesh_name chairtwo_64.obj
./snap2mesh.sh --data_path /home/ubuntu/georgia/data/chair --snap_name checkpoint.ingp --mesh_resolution 128 --mesh_name chairtwo_128.obj
./snap2mesh.sh --data_path /home/ubuntu/georgia/data/chair --snap_name checkpoint.ingp --mesh_resolution 256 --mesh_name chairtwo_256.obj
./snap2mesh.sh --data_path /home/ubuntu/georgia/data/chair --snap_name checkpoint.ingp --mesh_resolution 512 --mesh_name chairtwo_512.obj

cd /home/ubuntu/georgia/data/chair/

zip chair_compare.zip chairtwo_64.obj chairtwo_128.obj chairtwo_256.obj chairtwo_512.obj
