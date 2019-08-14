#!/bin/bash
#Script para parar os serviços

cd /opt/AVAPolos

source /opt/AVAPolos/variables.sh
source /opt/AVAPolos/functions.sh

#if ps ax | grep -v grep | grep docker > /dev/null
#then
    echo "Finalizando containers"

    docker-compose down
    #stopWiki
    #stopMoodle
    #stopDBMaster
    #stopDBSync
    #stopEducapes

#    sudo systemctl stop docker

#    sudo rm /var/lib/docker/network/files/local-kv.db

#    sudo systemctl start docker

#else
#    echo "Docker não está rodando, containers já estão finalizados!"
#fi
