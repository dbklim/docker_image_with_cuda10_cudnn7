#!/bin/bash

# Предоставление прав на запуск скриптов
chmod +x install_nvidia-driver.sh
chmod +x install_nvidia-container-toolkit.sh

# Установка драйвера для видеокарты (CUDA 10.2 требует версию >=440, CUDA 10.1 - версию >=418, CUDA 10.0 - версию >=410)
./install_nvidia-driver.sh 440

# Установка nvidia-container-toolkit (https://github.com/NVIDIA/nvidia-docker)
./install_nvidia-container-toolkit.sh

# Сборка образа с CUDA 10.X и cuDNN 7.6.5 на основе Dockerfile_cuda10.X_devel (в качестве исходного образа используется Ubuntu 19.10)
if [[ $1 != "cuda10.0" ]] && [[ $1 != "cuda10.1" ]] && [[ $1 != "cuda10.2" ]]; then
    if [ -n "$1" ]; then
        echo "Warning! Unsupported value '${1}', default value 'cuda10.2' is used."
    fi
    CUDA_VERSION="cuda10.2"
else
    CUDA_VERSION="$1"
fi

docker build -f Dockerfile_${CUDA_VERSION}_devel -t ${CUDA_VERSION}_cudnn7.6:devel .

# Проверка работоспособности
docker run --gpus all -ti --rm ${CUDA_VERSION}_cudnn7.6:devel nvidia-smi