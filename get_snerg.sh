# !/bin/bash
# Clone the repo

# Create a conda environment
cd /home/ubuntu/georgia/google-research/snerg
conda create --name snerg python=3.8; conda activate snerg
# Prepare pip
conda install pip; pip install --upgrade pip
# Install requirements
pip install -r requirements.txt

# (Optional) do extra stuff to get GPU support
# You might need to change cuda11 for your specific CUDA version - inspect this via "lspci | grep -i nvidia"
pip install flax==0.5.1
#pip install --upgrade jax==0.3.1 jaxlib==0.1.74+cuda12.cudnn89 -f https://storage.googleapis.com/jax-releases/jax_releases.html
#pip install -U "jax[cpu]"
#pip install jaxlib
pip install -U "jax[cuda11_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
# Ensure that your environment can "talk" to the GPU
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/conda/envs/snerg/lib
cd /home/ubuntu/georgia/google-research/
# Train the model, using the example dataset (included in the repo)
python -m snerg.train \
  --data_dir=snerg/example_data \
  --train_dir=/tmp/snerg_test \
  --max_steps=5 \
  --factor=2 \
  --batch_size=512
