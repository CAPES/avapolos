#!/bin/bash

sudo cp ava.desktop /usr/share/applications
sudo chmod 644 /usr/share/applications/ava.desktop

basicInput(){ # $1 = message; $2 = option 1 (padrão); $3 = option 2; $4 = useDefault (1 or 0); $5 = errorMessage #the user input is available in the variable $option
   option1=$(tr '[:upper:]' '[:lower:]' <<< "$2" )
   option2=$(tr '[:upper:]' '[:lower:]' <<< "$3" )
   if [ -z $4 ]; then
      useDefault="1";
   else
      useDefault=$4;
   fi
   if [ "$useDefault" = "1" ]; then
      labelDefault=$(tr '[:lower:]' '[:upper:]' <<< "$2" )
   else
      labelDefault=$(tr '[:upper:]' '[:lower:]' <<< "$2" )
   fi
   option="§"
   while ! [[ "$useDefault" = "1" && -z $option ]] && [ ! "$option"  = "$option1" ] && [ ! "$option"  = "$option2" ]; do
      if [ ! -z "$5" ]; then
         if [ ! "$option" = "§" ]; then
            echo $5
         fi
      fi
      echo -e "$1 ($labelDefault/$3)"
      read option
      option=$(tr '[:upper:]' '[:lower:]' <<< "$option" )

   done
}


#echo " "
echo "
  <AVAPolos Solution - An Information Technology solution that enables 
  educational institutions to offer 'online' courses on places with no 
  Internet connection, or where it works poorly.> Copyright (C) <2019>
  <DED/CAPES - Coordenação de Aperfeiçoamento de Pessoal de Nível 
  Superior - CAPES - Brazil TI C3 - Centro de Ciências Computacionais 
  / Universidade Federal do Rio Grande - FURG - Brazil>

  Este programa é um software livre: você pode redistribuí-lo e/ou
  modificá-lo sob os termos da Licença Pública Geral GNU, conforme
  publicado pela Free Software Foundation, seja a versão 3 da Licença
  ou (a seu critério) qualquer versão posterior.

  Este programa é distribuído na esperança de que seja útil,
  mas SEM QUALQUER GARANTIA; sem a garantia implícita de
  COMERCIALIZAÇÃO OU ADEQUAÇÃO A UM DETERMINADO PROPÓSITO. Veja a
  Licença Pública Geral GNU para obter mais detalhes.

  Você deve ter recebido uma cópia da Licença Pública Geral GNU
  junto com este programa. Se não, veja <https://www.gnu.org/licenses/>.
"
#echo"

#    <AVAPolos Solution - An Information Technology solution that enables 
#    educational institutions to offer 'online' courses on places with no 
#    Internet connection, or where it works poorly.> Copyright (C) <2019>
#    <DED/CAPES - Coordenação de Aperfeiçoamento de Pessoal de Nível 
#    Superior - CAPES - Brazil TI C3 - Centro de Ciências Computacionais 
#    / Universidade Federal do Rio Grande - FURG - Brazil>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#"
#echo " "


basicInput "Deseja instalar a solução AVAPolos?" "sim" "nao" 0 "Você precisa selecionar uma opção!"

if [ "$option" = "nao" ]; then
  echo "Cancelando instalação.";
  exit;
elif [ "$option" = "sim" ]; then
  bash avapolos.sh y 0 postgresql;
fi
