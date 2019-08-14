#!/bin/bash

source /opt/AVAPolos/variables.sh
source /opt/AVAPolos/functions.sh

if [ ! $# -eq 1 ]; then
   echo "Wrong usage: tar file name should be passed."
else
   stopMoodle 
   stopDBMaster
   stopDBSync

   rm -rf data/$dataDirMaster data/$dataDirSync data/moodle/moodledata/filedir Export/ Import/* dadosExportados/*
   tar -xvzf $1

   startMoodle
   startDBMaster

fi



