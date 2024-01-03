#!/bin/bash -l
conda init bash
source ~/.bashrc
conda create -n myenv
eval "$(conda shell.bash hook)"
conda activate myenv
#source activate myenv
conda info

