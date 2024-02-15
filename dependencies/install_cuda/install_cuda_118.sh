ls /usr/local/ | grep cuda
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
chmod +x cuda_11.8.0_520.61.05_linux.run 
sudo ./cuda_11.8.0_520.61.05_linux.run --silent --toolkit

ls /usr/local/ | grep cuda
