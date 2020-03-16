#!/bin/bash

# Предоставление прав на запуск скриптов
chmod +x install_nvidia-driver.sh
chmod +x install_nvidia-container-toolkit.sh

# Установка драйвера для видеокарты версии 440 для CUDA 10.2 (для CUDA 10.1 нужен драйвер версии 418, для CUDA 10.0 - версии 410)
./install_nvidia-driver.sh $1

# Установка nvidia-container-toolkit (https://github.com/NVIDIA/nvidia-docker)
./install_nvidia-container-toolkit.sh

# Сборка образа с CUDA 10.X и cuDNN 7.6.5 на основе Dockerfile_cuda10.X_devel (в качестве исходного образа используется Ubuntu 19.10)
CUDA_VERSION=""
if [[ $1 != "cuda10.0" ]] && [[ $1 != "cuda10.1" ]] && [[ $1 != "cuda10.2" ]]; then
    CUDA_VERSION="cuda10.2"
else
    CUDA_VERSION="$1"
fi

docker build -f Dockerfile_${CUDA_VERSION}_devel -t ${CUDA_VERSION}_cudnn7.6:devel .

# Проверка работоспособности
docker run --gpus all -ti --rm ${CUDA_VERSION}_cudnn7.6:devel nvidia-smi