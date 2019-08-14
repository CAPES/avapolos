#!/usr/bin/env bash

clear

echo " "
echo "+-----------------------+"
echo "|Empacotamento AVAPolos|"
echo "+-----------------------+"
echo " "
echo "Dica: pode-se copiar a pasta data da instalação atual executando da seguinte forma:"
echo "	bash build.sh pull-data"
echo " "

start=$(date +%s)

cd ../raiz
raiz=$PWD

command=$(ping4 -c 3 www.google.com)
if [ $? -ne 0 ]; then
#if [ 1 -ne 0 ]; then #DEBUG
	echo "Não foi possível atualizar as dependências, host offline."
else
	echo "Internet detectada"
	cd install/resources/
	sudo bash update_resources.sh
	cd $raiz
fi

echo -e "Assegurando permissões corretas.\r"
sudo chown $USER:$USER -R "$raiz"

cd "$raiz"/install/resources/servicos/
mkdir -p postgres

if [ ! -d "postgres/data" ]; then
	cp postgresql.tar.gz postgres
	cd postgres
	tar xfz postgresql.tar.gz
	rm postgresql.tar.gz
fi

cd "$raiz"/install/resources/servicos/postgres

if [ "$1" = "pull-data" ]; then
	pwd=$PWD
	echo "Importando dados da instalação atual."
	sudo bash /opt/AVAPolos/stop.sh
	cd /opt/AVAPolos
	echo -e "Compactando pacote de servicos.\r"
	sudo tar cfz postgresql.tar.gz data
	cd $pwd
	sudo cp -rf /opt/AVAPolos/postgresql.tar.gz .
	sudo chown $USER:$USER -R "$raiz"
	sudo bash /opt/AVAPolos/start.sh
else
	echo -e "Usando dados da pasta build.\r"
	echo -e "Compactando pacote de servicos.\r"
  tar cfz postgresql.tar.gz data
fi

mv -f postgresql.tar.gz ..
cd "$raiz"

mkdir -p ../pack

echo -e "Copiando arquivos.\r"

cp -ru * ../pack
# cp -ru install ../pack
# cp -u start.sh ../pack
# cp -u stop.sh ../pack
# cp -u fix_ip.sh ../pack

cd ../pack

echo -e "Empacotando.\r"

#Excluir lixo

cd install/resources/servicos/

rm -rf postgres

cd ../../../

tar cfz AVAPolos.tar.gz *

mv AVAPolos.tar.gz ../stage

cd ../stage

makeself --target /opt/AVAPolos_installer/ --needroot . AVAPolos_instalador_prototipo_IES "Instalador da solução AVAPolos" "./startup.sh"

#Mudar o nome

rm -rf AVAPolos.tar.gz
# if [ -f "../instalador/instaladoravapolos0.1.1" ]; then
#         sudo rm ../instalador/instaladoravapolos0.1.1
# fi
mv -f AVAPolos_instalador_prototipo_IES ..
cd ..
sudo rm -rf pack

end=$(date +%s)

runtime=$((end-start))

echo "
+-------------------------+
| Empacotamento Concluído |
+-------------------------+
Em "$runtime"s.
"
