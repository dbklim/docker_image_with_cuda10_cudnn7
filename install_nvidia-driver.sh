#!/bin/bash

# Установка драйвера для видеокарты (CUDA 10.2 требует версию >=440, CUDA 10.1 - версию >=418, CUDA 10.0 - версию >=410)
# Источник: https://docs.nvidia.com/deploy/cuda-compatibility/index.html#binary-compatibility__table-toolkit-driver
if [ -z "$1" ]; then
    DRIVER_VERSION="440"
else
    DRIVER_VERSION=$1
fi

add-apt-repository -y ppa:graphics-drivers/ppa
apt-get -y update
apt-get -y install nvidia-driver-${DRIVER_VERSION}