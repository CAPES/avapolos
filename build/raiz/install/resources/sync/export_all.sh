#!/bin/bash
#rafaelV2
echo " "
echo "--------------------"
echo "Exportação AVAPolos"
echo "--------------------"

source /opt/AVAPolos/variables.sh
source /opt/AVAPolos/functions.sh

cd /opt/AVAPolos/

bash switch.sh name

sudo rm -rf temp/*
sudo mkdir -p temp
sudo mkdir -p temp/.ssh

echo "Executando sincronização..."

createMasterFileDirList
createSyncFileDirList
chown -R avapolos:docker $masterFileDirListPath $syncFileDirListPath

createControlRecord 0 E 'instaladorAvapolos'
stopDBMaster
###TO-DO: tornar moodle inacessivel
clearQueue
#apagando o registro de controle do clone para que uma nova clonagem possa ser gerada quando desejad

echo "Copiando arquivos..."

sudo cp .ssh/key.tar.gz temp/.ssh/
sudo cp -r install temp/
sudo cp start.sh temp/
sudo cp stop.sh temp/
sudo touch temp/install/scripts/polo
sudo cp -r Export temp
sudo cp -r Import temp
#sudo cp -r *.ssh temp
sudo rm -rf temp/Export/Fila/*
sudo rm -rf temp/Import/*

# if [ ! -z $(ls temp/Export/Fila) ]; then
   #sudo rm -rf temp/Export/Fila/*
# fi

# if [ ! -z $(ls temp/Import) ]; then
   #sudo rm -rf temp/Import/*
# fi

# if [ ! -z $(ls temp/dadosExportados) ]; then
	sudo rm -rf temp/dadosExportados/*
# fi

cd temp

echo "PostgreSQL selecionado"
sudo rm install/resources/servicos/postgresql.tar.gz
cd ..
echo "Compactando serviços, pode demorar um pouco."
sudo tar cpfz postgresql.tar.gz data
mv postgresql.tar.gz temp/install/resources/servicos/postgresql.tar.gz
cd temp

echo "Compactando clonagem, pode demorar um pouco."

tar cfz AVAPolos.tar.gz * .ssh
mv AVAPolos.tar.gz ..
cd ..
sudo rm -rf temp
sudo mkdir -p temp

sudo cp /opt/AVAPolos_installer/*.sh temp/
sudo cp /opt/AVAPolos_installer/*.desktop temp/
sudo cp /opt/AVAPolos_installer/*.ico temp/
sudo cp /opt/AVAPolos_installer/avapolos temp/
sudo cp AVAPolos.tar.gz temp/

echo "Compactando instalador, pode demorar um pouco..."

cd temp

makeself --target /opt/AVAPolos_installer/ --nooverwrite --needroot . instaladoravapolosPOLO "Instalador da solução AVAPolos" "./startup.sh"
mv instaladoravapolosPOLO ../../
chmod 644 ../../instaladoravapolosPOLO
sudo rm -rf temp

# #Workaround para bug do docker
# for iface in $(ip -o -4 addr show | grep 172.12 | awk '{print $2}'); do
# 	sudo ip link delete $iface
# done

# sudo docker-compose up --no-start

# if [ -f ".traefik_enabled" ]; then
#   startContainer traefik
#   startContainer hub_name
#   stopContainer hub_80
# else
#   stopContainer traefik
#   stopContainer hub_name
#   startContainer hub_80
# fi

# startContainer downloads
# startWiki
# startMoodle
# startDBMaster
# stopDBSync

cd /opt/AVAPolos
bash stop.sh
bash start.sh

echo "
+------------------------------------------------------+
|                                                      |
|                      AVAPolos                        |
|                                                      |
+------------------------------------------------------+
|                                                      |
|  Clonagem concluída!                                 |
|  Arquivo instaladoravapolosPOLO                      |
|  Disponível em /opt/                                 |
|  Aguarde a inicialização dos serviços.               |
|                                                      |
+------------------------------------------------------+
"
