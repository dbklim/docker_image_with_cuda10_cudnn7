#!/bin/bash

# Если при установке nvidia-docker2 возникла следующая ошибка:
# nvidia-docker2 : Зависит: docker-ce (= 5:18.09.5~3-0~ubuntu-bionic) но он не может быть установлен или
#                           docker-ee (= 5:18.09.5~3-0~ubuntu-bionic) но он не может быть установлен
# E: Невозможно исправить ошибки: у вас зафиксированы сломанные пакеты.
# Решение взято отсюда https://github.com/NVIDIA/nvidia-docker/issues/607

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
apt-get -y update
apt-get -y install docker-ce
service docker restart
