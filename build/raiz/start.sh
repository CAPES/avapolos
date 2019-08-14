#!/bin/bash

set -e

cd /opt/AVAPolos

source /opt/AVAPolos/variables.sh
source /opt/AVAPolos/functions.sh

if ! ps ax | grep -v grep | grep docker > /dev/null
then
    echo "Docker não está rodando, inicializando.."
    sudo systemctl start docker
fi


#Workaround para bug do docker
for iface in $(ip -o -4 addr show | grep 172.12 | awk '{print $2}'); do
	sudo ip link delete $iface
done

sudo docker-compose up --no-start

if [ -f ".traefik_enabled" ]; then
  startContainer traefik
  startContainer hub_name
  stopContainer hub_80
else
  stopContainer traefik
  stopContainer hub_name
  startContainer hub_80
fi

startContainer downloads
startWiki
startMoodle
startDBMaster
stopDBSync
startEducapes

# if [ -f /opt/dspace/data-solr ]; then
#   sed -i 's/\#/http:\/\/educapes.avapolos\/jspui/g' data/hub/public/index.html
#   startEducapes
# elif [ -f /opt/dspace/done ]; then
#   sed -i 's/\#/http:\/\/educapes.avapolos\/jspui/g' data/hub/public/index.html
#   startEducapes
# else
#   sed -i 's/http:\/\/educapes.avapolos\/jspui/\#/g' data/hub/public/index.html
# fi

echo "
+------------------------------------------------------+
|                                                      |
|  Serviços iniciados!                                 |
|                                                      |
|  Acesse o seguinte endereço no seu navegador:        |
|                                                      |
|  http://menu.avapolos/                               |
|                                                      |
+------------------------------------------------------+
"

sleep 10
