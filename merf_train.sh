# Copyright 2023 The Google Research Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

SCENE=garden
DATA_DIR=/home/ubuntu/georgia/google-data/nerf_360/
CHECKPOINT_DIR=/home/ubuntu/georgia/google-checkpoints/merf/"$SCENE"

export CUDA_VISIBLE_DEVICES=0
export XLA_PYTHON_CLIENT_PREALLOCATE=true #prevents jax from preallocating 75% of GPU memory on start -- this can interfere with tensorflow also attempting to use GPU leading to OOM error
export XLA_PYTHON_CLIENT_MEM_FRACTION=0.75
export XLA_PYTHON_CLIENT_ALLOCATOR=platform

cd /home/ubuntu/georgia/google-research/merf/
python /home/ubuntu/georgia/google-research/merf/train.py \
  --gin_configs=configs/merf.gin \
  --gin_bindings="Config.data_dir = '${DATA_DIR}/${SCENE}'" \
  --gin_bindings="Config.checkpoint_dir = '${CHECKPOINT_DIR}'"
