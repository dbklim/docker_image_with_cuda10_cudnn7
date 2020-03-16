#!/bin/bash

# Установка Docker в Ubuntu 16.04-19.10
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose