#/bin/bash

##
# Works in ubuntu 21.10

lsb_release -a

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes
sudo apt-get --purge autoremove -q -y --force-yes && sudo apt-get autoclean -q -y --force-yes
sudo rm -rf ~/.cache/thumbnails/*
sudo dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt-get -y purge

#nginx
sudo apt install nginx -q -y --force-yes
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl restart nginx
sudo ufw allow 'Nginx HTTP'
sudo chmod -R 755 /var/www/html/*
sudo nginx -v

# nest.owinteractive.com
# read -p "Endereço do projeto  sem http(s) Ex:nest.owinteractive.com : " site
# echo "$site"
