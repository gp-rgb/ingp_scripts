ls /usr/local/ | grep cuda
wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run

chmod +x cuda_12.2.0_535.54.03_linux.run
sudo ./cuda_12.2.0_535.54.03_linux.run --silent --toolkit

ls /usr/local/ | grep cuda
