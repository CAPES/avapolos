
#!/bin/bash

#-------------------------------------------#
# AVAPolos - Script de configuração de rede #
#-------------------------------------------#

echo "-----------------"
echo "Configurando Rede"
echo "-----------------"

#----------------------------------------------------------

rm -rf /opt/AVAPolos/install/resources/servicos/networking/enable

#docker-compose down -d

  #if [ -f /etc/init.d/network-manager ]; then
    echo "Habilitando serviço padrão de gerenciamento de redes."
    sudo systemctl unmask NetworkManager
    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager
  #fi

  echo "Gerando backup dos perfis de conexão anteriores."
  cd /etc/netplan/old
  sudo cp -f *.yaml ..
  echo "Ativando netplan"
  sudo netplan apply

   
  cd /lib/systemd/network

  sudo rm -f 00-avapolos.network
  systemctl restart systemd-networkd.service
  systemctl disable systemd-networkd.service


  echo "Gerando arquivo /etc/hosts"
  cd /etc/old
  sudo cp hosts ..
