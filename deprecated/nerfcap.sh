conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate ingp_env8

export QT_QPA_PLATFORM=offscreen

## PATH SETTINGS
ngp_path=/home/ubuntu/georgia/instant-ngp/
data_path=/home/ubuntu/georgia/data/

python3 ${ngp_path}/scripts/nerfcapture2nerf.py --save_path "dir1/dir2" --n_frames 20

