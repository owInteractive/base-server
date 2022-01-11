#/bin/bash

##
# Works in ubuntu 21.10

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes
sudo apt-get --purge autoremove -q -y --force-yes && sudo apt-get autoclean -q -y --force-yes
sudo rm -rf ~/.cache/thumbnails/*
sudo dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt-get -y purge