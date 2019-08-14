#!/bin/bash

#interface=$(route | grep '^default' | head -n1 | grep -o '[^ ]*$') #Precisa do pacote net-tools
#ip=$(ip -o -f inet addr show | grep $interface | head -n1 | awk '/scope global/ {print $4}')
#ip=${ip: 0:-3}

getNetIfs(){
   echo $(ls -l /sys/class/net/ | grep -vE 'virtual|total' | rev | cut -d"/" -f 1 | rev)
}


interface=$(route | grep '^default' | grep -o '[^ ]*$') #Precisa do pacote ne$
  if [ -z "$interface" ]; then
    interfacelist=$(getNetIfs) #Precisa do paco$
    
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
    echo $c
    if [ $c -eq 1 ]; then
      interface="$if1"
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
    interface=$if1  
  fi


ip=$(ip -o -f inet addr show | grep "$interface" | awk '/scope global/ {print $4}')
ip=$(echo $ip | cut -d "/" -f1)

echo $ip
