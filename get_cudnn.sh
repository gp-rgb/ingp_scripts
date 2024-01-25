cudnn_version=5.15.0*
cuda_version=cuda11.8
distro=ubuntu2004
arch=x86_64

sudo apt-get install linux-headers-$(uname -r)
sudo apt-key del 7fa2af80

wget https://developer.download.nvidia.com/compute/cuda/repos/<distro>/<arch>/cuda-archive-keyring.gpg
sudo mv cuda-archive-keyring.gpg /usr/share/keyrings/cuda-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/<distro>/<arch>/ /" | sudo tee /etc/apt/sources.list.d/cuda-<distro>-<arch>.list
wget https://developer.download.nvidia.com/compute/cuda/repos/<distro>/<arch>/cuda-<distro>.pin
sudo mv cuda-<distro>.pin /etc/apt/preferences.d/cuda-repository-pin-600

sudo apt-get install libcudnn8=${cudnn_version}-1+${cuda_version}
sudo apt-get install libcudnn8-dev=${cudnn_version}-1+${cuda_version}
sudo apt-get install libcudnn8-samples=${cudnn_version}-1+${cuda_version}


