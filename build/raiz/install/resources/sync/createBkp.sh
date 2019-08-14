#!/bin/bash

source /opt/AVAPolos/variables.sh
source /opt/AVAPolos/functions.sh

if [ ! $# -eq 1 ]; then
   echo "usage: provide the tar name output"
else
   stopMoodle
   stopDBMaster
   stopDBSync

   tar -cvzf $1 data/$dataDirMaster data/$dataDirSync data/moodle/moodledata/filedir Export/ dadosExportados/

   startMoodle
   startDBMaster
fi
