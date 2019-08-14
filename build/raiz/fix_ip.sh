#!/bin/bash

ip=$(bash install/scripts/get_ip.sh)
echo "IP: $ip"

sudo sed -i '/avapolos/d' /etc/hosts
sudo -- sh -c "echo '#Automatically set by AVA-Polos solution.' >> /etc/hosts"
sudo -- sh -c "echo '$ip avapolos' >> /etc/hosts"
sudo -- sh -c "echo '$ip moodle.avapolos' >> /etc/hosts"
sudo -- sh -c "echo '$ip wiki.avapolos' >> /etc/hosts"
sudo -- sh -c "echo '$ip educapes.avapolos' >> /etc/hosts"
sudo -- sh -c "echo '$ip traefik.avapolos' >> /etc/hosts"
sudo -- sh -c "echo '$ip menu.avapolos' >> /etc/hosts"
sudo -- sh -c "echo '$ip downloads.avapolos' >> /etc/hosts"

echo "Feito."
