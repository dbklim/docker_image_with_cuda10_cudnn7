#!/bin/bash

# Установка драйвера для видеокарты версии 410.104
add-apt-repository -y ppa:graphics-drivers/ppa
apt-get -y update
apt-get -y install nvidia-driver-410