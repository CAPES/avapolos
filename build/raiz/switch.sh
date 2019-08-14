#!/usr/bin/env bash

ip=$(bash install/scripts/get_ip.sh)

if [ $1 = "name" ]; then

  
  bash stop.sh
  echo "Chaveando para uso de nomes"
#  echo 10
  str="$ip:81"
  sed -i "s/"$str"/moodle.avapolos/g" data/moodle/public/config.php
  sed -i "s/"$str"/moodle.avapolos/g" data/hub/public/index.html
#  echo 14
  str="$ip:82"
  sed -i "s/"$str"/wiki.avapolos/g" data/wiki/public/LocalSettings.php
  sed -i "s/"$str"/wiki.avapolos/g" data/hub/public/index.html
#  echo 18
  str="$ip:83\/jspui"
  sed -i "s/"$str"/educapes.avapolos\/jspui/g" data/hub/public/index.html
#  echo 21
  str="$ip:84"
  sed -i "s/"$str"/downloads.avapolos/g" data/downloads/public/index.html
  sed -i "s/"$str"/downloads.avapolos/g" data/hub/public/index.html
#  echo 25
  touch .traefik_enabled
  bash startsw.sh
  exit
fi
if [ $1 = "ip" ]; then
  bash stop.sh

  echo "Chaveando para uso de ip"
#  echo 34
  sed -i "s/moodle.avapolos/"$ip":81""/g" data/moodle/public/config.php
  sed -i "s/moodle.avapolos/"$ip":81/g" data/hub/public/index.html
#  echo 37
  sed -i "s/wiki.avapolos/"$ip":82/g" data/wiki/public/LocalSettings.php
  sed -i "s/wiki.avapolos/"$ip":82/g" data/hub/public/index.html
#  echo 40
  sed -i "s/educapes.avapolos\/jspui/"$ip":83\/jspui/g" data/hub/public/index.html
#  echo 42
  sed -i "s/downloads.avapolos/"$ip":84/g" data/downloads/public/index.html
  sed -i "s/downloads.avapolos/"$ip":84/g" data/hub/public/index.html

  rm -rf .traefik_enabled
  bash startsw.sh
  exit
fi

echo "Uso: switch.sh [name/ip]"
