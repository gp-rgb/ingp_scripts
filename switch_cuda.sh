python -m venv /home/ubuntu/georgia/venvs/cuda116_env
python -m venv /home/ubuntu/georgia/venvs/cuda122_env
python -m venv /home/ubuntu/georgia/venvs/cuda118_env

if [[ ${1} == "cuda_11.6" ]];then
    . /home/ubuntu/georgia/venvs/cuda116_env/bin/activate
    export PATH=/usr/local/cuda-11.6/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64:$LD_LIBRARY_PATH
    echo "cuda 11.6 activated"
    nvcc -V
    nvidia-smi
fi

if [[ ${1} == "cuda_12.2" ]]; then
    . /home/ubuntu/georgia/venvs/cuda122_env/bin/activate
    export PATH=/usr/local/cuda-12.2/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH
    nvcc -V
    nvidia-smi

fi

if [[ ${1} == "cuda_11.8" ]]; then
    source /home/ubuntu/georgia/venvs/cuda118_env/bin/activate
    export PATH=/usr/local/cuda-11.8/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH
    nvcc -V
    nvidia-smi

fi

