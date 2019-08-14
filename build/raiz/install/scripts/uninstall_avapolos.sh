#!/bin/bash

echo " "
echo "-----------------------"
echo "Desinstalando AVAPolos"
echo "-----------------------"

cd /opt/AVAPolos

sudo bash stop.sh

cd install/resources/servicos/networking
docker-compose down
docker network rm traefik_proxy

cd /opt/AVAPolos/install/scripts

if [ "$1" = "y" ]; then
	sudo bash uninstall_docker.sh y
else
	sudo bash uninstall_docker.sh
fi

sudo rm -r /opt/AVAPolos

echo " "
echo "-----------------------"
echo "Desinstalação concluída"
echo "-----------------------"
