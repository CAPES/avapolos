#!/bin/bash

mkdir -p ~/.ssh
cp /opt/AVAPolos/.ssh/key.tar.gz ~/.ssh/.
cd ~/.ssh
tar xvfz key.tar.gz
cat ~/.ssh/key.pub >> ~/.ssh/authorized_keys
