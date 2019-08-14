#!/bin/bash

#-------------------------------------------#
# AVAPolos - Script de configuração de rede #
#-------------------------------------------#

if [ "$EUID" -ne 0 ]; then
    echo "Este script precisa ser rodado como root."
    exit
fi

pwd=$PWD

#----------------------------------------------------------

echo " "
echo "-----------------"
echo "Configurando Rede"
echo "-----------------"

#----------------------------------------------------------

rm -rf /opt/AVAPolos/install/resources/servicos/networking/enable

setupInterface() {

  interface=$(route | grep '^default' | grep -o '[^ ]*$') #Precisa do pacote net-tools

  if [ -z "$interface" ]; then

    interfacelist=$(ifconfig | grep ^[a-zA-Z] | cut -d":" -f1) #Precisa do pacote net-tools
    
    c=0
    for iface in $interfacelist; do
      if ! [ "$iface" = "lo" ]; then
        if ! [[ "$iface" == *"wl"* ]]; then
          if ! [[ "$iface" == *"docker"* ]]; then
            if ! [[ "$iface" == *"br"* ]]; then
              if ! [[ "$iface" == *"veth"* ]]; then    
                #echo "usando interface: $iface"
                c=$((c+1));
                eval "if$c=$iface";
              fi
            fi
          fi
        fi
      fi
    done

    if [ $c -eq 1 ]; then
      interface=$if1
    else
      echo "A interface principal não foi detectada automaticamente"
      option="x"
      while [ ! -z "$option" ] && [ ! "$option" = "s" ] && [ ! "$option" = "n" ]; do
         echo -e "Deseja selecionar uma manualmente? (S/n)"
         read option
         option=$(tr '[:upper:]' '[:lower:]' <<< "$option" )
      done

      if [ ! -z "$option" ] && [ "$option" = "n" ]; then
        echo "Uma interface precisa ser selecionada!"
        exit 1
      fi

      #$c=$(($c-1))

      echo "Interfaces detectadas:"
      for counter in $(seq 1 $c); do
        var="if$counter"
        echo "$counter. ${!var}"
      done
      flag=false
      while [ "$flag" = "false" ]; do
        echo "Selecione uma interface: (1-$c)"
        read option
        #echo "opção digitada:$option"
        for counter in $(seq 0 $c); do
          #echo $counter #DEBUG
          if [ "$option" = "$counter" ]; then
            flag=true
          fi
        done
      done
      var="if$option"
      interface=${!var}
    fi
  else
    c=0
    for iface in $interface; do
      if ! [ "$iface" = "lo" ]; then
        if ! [[ "$iface" == *"wl"* ]]; then
          if ! [[ "$iface" == *"docker"* ]]; then
            if ! [[ "$iface" == *"br"* ]]; then
              if ! [[ "$iface" == *"veth"* ]]; then    
                echo "usando interface: $iface"
                c=$((c+1));
                eval "if$c=$iface";
              fi
            fi
          fi
        fi
      fi
    done
    interface=$if1  
  fi

  #echo "interface gerada pelo setupInterface: $interface"

}

setupIP() {

  #echo "$interface"

  enableDnsmasq="false"

  ip=$(ip -o -f inet addr show | grep "$interface" | awk '/scope global/ {print $4}')

  if [ -z $ip ]; then
    #echo "Nenhum IP detectado, configurando como polo."

    ip="10.254.0.1/16"
    gw="10.254.0.1"
    ns1="8.8.8.8"
    ns2="8.8.4.4"

    echo " "
    echo "-----------------------------------------------------"
    echo "Nenhum ip detectado, utilizando configurações padrão." 
    echo "                                                     "
    echo "Os seguintes parâmetros serão configurados:          "
    echo "Interface:$interface				       "
    echo "IP do Host: 10.254.0.1/16                            "
    echo "Servidor DNS: 10.254.0.1                             "
    echo "Gateway da rede: 10.254.0.1                          "
    echo "-----------------------------------------------------"
    echo "Subrede estática: 10.254.0.0                         "
    echo "Subrede DHCP: 10.254.1.0                             "
    echo "-----------------------------------------------------"
    echo " "

    enableDnsmasq="true"
    #echo "IP Detectado: $ip"

  fi
  
}
getGW() {

  gw=$(ip route | grep "default" | grep "$interface" | awk '{print $3}')

}

getNS(){
  cmdRet=$(systemd-resolve --status)

  hasDns=$(echo $cmdRet | grep "DNS Servers: ")

  if [ -z "$hasDns" ]; then
    #echo "nenhum dns detectado"
    ns1="8.8.8.8"
    ns2="8.8.4.4"

  else

    ifstart=$(echo "$cmdRet" | grep "($interface)" -m 1 -n | cut -d":" -f1)

    lineEnd=$(echo "$cmdRet" | wc -l)

    ifFromEnd=$(( $lineEnd - $ifstart ))

    #try to find DNS Domain
    endLink=$(echo "$cmdRet" | tail -n $ifFromEnd | grep 'Link' -m 1 -n | cut -d":" -f1)
    if [ -z "$endLink" ]; then
       #try to find next link
       endLink=$(echo "$cmdRet" | tail -n $ifFromEnd | grep 'DNS Domain' -m 1 -n | cut -d":" -f1)
       if [ -z "$endLink" ]; then
          endLink=$lineEnd
       fi
    fi
    if [ ! $endLink -eq $lineEnd ]; then
       endLink=$(( $endLink - 1))
    fi

    cmdFromIf=$(echo "$cmdRet" | tail -n $ifFromEnd | head -n $endLink)

  fi

}

generateConfig() {

  if [ -f /etc/init.d/network-manager ]; then
    echo "Desabilitando serviço padrão de gerenciamento de redes."
    sudo systemctl disable NetworkManager
    sudo systemctl stop NetworkManager
    sudo systemctl mask NetworkManager
  fi

  echo "Gerando backup dos perfis de conexão anteriores."
  cd /etc/netplan
  sudo mkdir -p old
  sudo mv -f *.yaml old
  echo "Desativando netplan"
  sudo netplan apply

  if [ -z $ns1 ]; then
    ns1=8.8.4.4
  fi

  if [ -z $ns2 ]; then
    ns2=8.8.8.8
  fi
   
  cd /lib/systemd/network

  echo "Criando arquivo de configuração: 00-avapolos.network"

  echo -e "[Match]" > 00-avapolos.network
  echo -e "Name=$interface" >> 00-avapolos.network
  echo -e " " >> 00-avapolos.network
  echo -e "[Link]" >> 00-avapolos.network
  echo -e "RequiredForOnline=no" >> 00-avapolos.network
  echo -e " " >> 00-avapolos.network
  echo -e "[Network]" >> 00-avapolos.network
  echo -e "IgnoreCarrierLoss=true" >> 00-avapolos.network
  echo -e "ConfigureWithoutCarrier=true" >> 00-avapolos.network
  echo -e "LinkLocalAddressing=ipv6" >> 00-avapolos.network
  echo -e "Address=$ip" >> 00-avapolos.network
  echo -e "Gateway=$gw" >> 00-avapolos.network
  echo -e "DNS=$ns1" >> 00-avapolos.network
  echo -e "DNS=$ns2" >> 00-avapolos.network
  sudo chmod 644 00-avapolos.network
  command=$(systemctl restart systemd-networkd.service)
  if [ $? -ne 0 ]; then
    echo "Houve um erro na aplicação da configuração"
    exit 2
  else
    echo "Configurações aplicadas com sucesso."
    systemctl enable systemd-networkd.service
  fi
}
generateHosts() {

  echo "Gerando arquivo /etc/hosts"
  hosts_ip=$(echo $ip | cut -d "/" -f1)
  cd /etc/
  sudo mkdir -p old
  sudo cp -f hosts old 
  sudo sed -i '/avapolos/d' hosts
  sudo sed -i '/AVA-Polos/d' hosts
  echo -e "#Automatically set by AVA-Polos solution." >> /etc/hosts
  echo -e "$hosts_ip avapolos" >> /etc/hosts
  echo -e "$hosts_ip moodle.avapolos" >> /etc/hosts
  echo -e "$hosts_ip wiki.avapolos" >> /etc/hosts
  echo -e "$hosts_ip educapes.avapolos" >> /etc/hosts
  echo -e "$hosts_ip traefik.avapolos" >> /etc/hosts
  echo -e "$hosts_ip menu.avapolos" >> /etc/hosts
  echo -e "$hosts_ip downloads.avapolos" >> /etc/hosts
}

main() {

  #echo "setupInterface"
  setupInterface
  #echo "setupIP"
  setupIP

  if [ "$enableDnsmasq" = "true" ]; then
    #echo "enablednsmasq=true"
    cd $pwd/../resources/servicos/networking
    touch enable
  else
    #echo "enablednsmasq=false"
    #echo "getGW"
    getGW
    #echo "getNS"
    getNS

    echo " "
    echo "-----------------------------------------------------"
    echo "Os seguintes parâmetros serão configurados:"
    echo "Interface:$interface"
    echo "IP do Host: $ip"
    echo "Gateway da rede: $gw"
    echo "-----------------------------------------------------"
    echo " "

  fi

  cd $pwd/../resources/servicos/networking
  if [ -f enable ]; then
    echo "$pwd/../resources/servicos/networking/enable"
    echo "Parando serviço padrão de nomes"
    sudo systemctl stop systemd-resolved
    sudo systemctl disable systemd-resolved
    sudo systemctl mask systemd-resolved
    
    echo "Inicializando, pode ser acessado pela porta 5380. (admin/admin)"
    docker-compose up -d
  fi

  generateConfig
  generateHosts

  cd /opt/AVAPolos

  touch .traefik_enabled

  echo "Criando rede para o proxy reverso."
  docker network create traefik_proxy

}

#----------------------------------------------------------

main
