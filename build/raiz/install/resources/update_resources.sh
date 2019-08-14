#!/bin/bash

if [ "$EUID" -e 0 ]; then
    echo "Este script não pode ser rodado como root."
    exit
fi

echo "Atualizando dependências de build."

sudo apt-get install -y \
    apt-transport-https \
    net-tools \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    apt-rdepends \
    curl \
    makeself \

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "Atualizando docker."

sudo apt install docker-ce -y
sudo apt-get update

version=$(lsb_release -r -s)

cd imagens
bash update.sh
cd ../deps_$version
bash update.sh
echo "Feito."
