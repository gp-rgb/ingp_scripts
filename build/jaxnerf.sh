#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda create --name jaxnerf python=3.10 pip;  conda activate jaxnerf

cd /home/ubuntu/georgia/google-research/
git clone -n --depth=1 --filter=tree:0 \
    https://github.com/google-research/google-research.git
cd google-research
git sparse-checkout set --no-cone jaxnerf
git checkout
mv jaxnerf ../
cd ../
rm -r google-research


cd /home/ubuntu/georgia/google-research/jaxnerf/
pip install -r requirements.txt
pip install --upgrade "jax[cuda12_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
#cd /home/ubuntu/georgia/google-research/
#bash jaxnerf/train.sh demo /home/ubuntu/georgia/google-data/
#bash jaxnerf/eval.sh demo /home/ubuntu/georgia/google-data/
