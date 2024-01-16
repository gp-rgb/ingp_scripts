# ingp_scripts
## Description of Repository Purpose
This repository contains shell scripts to:
1. Build an executable instance of Instant-NGP on Amazon EC2 machine.
2. Train a NeRF using the executable instance on a variety of Dataset types (video, images, blender and record3d).

## Environment Variables
Ensure that environment variables inside `build.sh` and `train.sh` are updated to reflect the location of the Instant-NGP repository, and the parent directory of the datasets to train the NeRF model on.

```
ngp_path=/path/to/.../Instant-NGP/
data_path=/path/to/parent/directory/of/datasets/
```
## AWS EC2 Details
The machine used to execute the scripts above has the following details.

<img width="363" alt="Screen Shot 2024-01-17 at 9 14 37 am" src="https://github.com/gp-rgb/ingp_scripts/assets/131956221/dbd631f6-3ee2-49a2-8c9f-75f61fb11e89">

