#!/bin/bash

cd ~
ssh-keygen -f ~/.ssh/key -t rsa -P ""
cat ~/.ssh/key.pub | cat >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
cd .ssh
mkdir -p /opt/AVAPolos/.ssh
tar cvfzp /opt/AVAPolos/.ssh/key.tar.gz key key.pub

#mv ~/key.tar.gz /opt/AVAPolos/
#rm /home/avapolos/key.tar.gz
