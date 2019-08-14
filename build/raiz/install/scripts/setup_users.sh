#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Este script precisa ser rodado como root"
    exit
fi

user="avapolos"

echo "Criando usuário avapolos."
useradd -s /bin/bash -c "Usuário da solução AVAPolos" -m -N -g docker -G sudo $user

#Checar segurança, testar ssh por chave privada para não precisar de senha, nesse caso -s nologin
echo -e "avapolos\navapolos" | sudo passwd $user

uid=$(id -u $user)
echo "UID: $uid"

cp generatePrivKey.sh /home/avapolos
cp installPrivKey.sh /home/avapolos

chown $uid:$uid /home/avapolos/generatePrivKey.sh
chown $uid:$uid /home/avapolos/installPrivKey.sh

##TESTAR