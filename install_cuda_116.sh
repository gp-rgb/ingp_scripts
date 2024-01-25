ls /usr/local/ | grep cuda
wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
chmod +x cuda_11.6.0_510.39.01_linux.run
sudo ./cuda_11.6.0_510.39.01_linux.run --silent --toolkit

ls /usr/local/ | grep cuda
