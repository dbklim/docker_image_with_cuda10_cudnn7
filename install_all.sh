#!/bin/bash

# Установка nvidia-driver-410 версии 410.104
add-apt-repository -y ppa:graphics-drivers/ppa
apt-get -y update
apt-get -y install nvidia-driver-410

# Установка nvidia-docker2 (https://github.com/NVIDIA/nvidia-docker)
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
apt-get install -y nvidia-docker2
pkill -SIGHUP dockerd

# Сборка образа с CUDA 10.0 и cuDNN 7.5.0 на основе Dockerfile (в качестве исходного образа используется Ubuntu 18.04)
docker build -t cuda10.0_cudnn7.5:1.0 .