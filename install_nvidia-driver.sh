#!/bin/bash

# Установка драйвера для видеокарты версии 440 для CUDA 10.2 (для CUDA 10.1 нужен драйвер версии 418, для CUDA 10.0 - версии 410)
# Источник: https://github.com/NVIDIA/nvidia-docker/wiki/CUDA#requirements
DRIVER_VERSION=""
if [[ $1 = "cuda10.0" ]]; then
    DRIVER_VERSION="410"
fi

if [[ $1 = "cuda10.1" ]]; then
    DRIVER_VERSION="418"
fi

if [[ $1 = "cuda10.2" ]]; then
    DRIVER_VERSION="440"
fi

if [ -z "$DRIVER_VERSION" ]; then
    DRIVER_VERSION="440"
fi

add-apt-repository -y ppa:graphics-drivers/ppa
apt-get -y update
apt-get -y install nvidia-driver-${RIVER_VERSION}