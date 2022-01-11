#/bin/bash

##
# Works in ubuntu 21.10

lsb_release -a

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes
sudo apt-get --purge autoremove -q -y --force-yes && sudo apt-get autoclean -q -y --force-yes
sudo rm -rf ~/.cache/thumbnails/*
sudo dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt-get -y purge
sudo apt-get install build-essential wget procps libarchive-tools libaio1 libxml2-dev openssh-client libssh2-1-dev libssh2-1 libpng-dev libfreetype6-dev libbz2-dev libgmp-dev libmagickwand-dev zlib1g-dev libicu-dev jpegoptim optipng pngquant gifsicle locales zip vim unzip git curl gnupg libcurl4-openssl-dev pkg-config libssl-dev libzip-dev  -q -y --force-yes

#nginx
sudo apt install nginx -q -y --force-yes
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'
sudo chmod -R 755 /var/www/html/*
sudo nginx -v

# nest.owinteractive.com
# read -p "Endereço do projeto  sem http(s) Ex:nest.owinteractive.com : " site
# echo "$site"

#certbot
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -sf /snap/bin/certbot /usr/bin/certbot

#node
sudo apt install nodejs npm -q -y --force-yes
nodejs --version