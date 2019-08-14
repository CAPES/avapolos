#!/bin/bash

echo " "
echo "---------------------------"
echo "Download das imagens Docker"
echo "---------------------------"
echo " "

echo "Download das imagens"

docker pull avapolos/postgres_bdr:master
docker pull avapolos/webserver:lite
docker pull avapolos/dnsmasq
docker pull traefik
docker pull avapolos/backup:stable
docker pull brendowdf/dspace-educapes
docker pull brendowdf/dspace-postgres-educapes:latest

docker save --output postgresql_master.tar avapolos/postgres_bdr:master
docker save --output webserver.tar avapolos/webserver:lite
docker save --output dspace.tar brendowdf/dspace-educapes
docker save --output db_dspace.tar brendowdf/dspace-postgres-educapes:latest
docker save --output backup.tar avapolos/backup:stable
docker save --output traefik.tar traefik
docker save --output networking.tar avapolos/dnsmasq

echo " "
echo "------------------"
echo "Download concluído"
echo "------------------"
echo " "
