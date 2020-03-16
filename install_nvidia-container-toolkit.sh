#!/bin/bash

# Установка nvidia-container-toolkit (Источник: https://github.com/NVIDIA/nvidia-docker)
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get -y update
apt-get -y install nvidia-container-toolkit
systemctl restart docker