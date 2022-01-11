#/bin/bash

##
# Works in ubuntu 21.10

lsb_release -a

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes
sudo apt-get --purge autoremove -q -y --force-yes && sudo apt-get autoclean -q -y --force-yes
sudo rm -rf ~/.cache/thumbnails/*
sudo dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt-get -y purge
sudo apt-get install build-essential gcc g++ make wget procps libarchive-tools libaio1 libxml2-dev openssh-client libssh2-1-dev libssh2-1 libpng-dev libfreetype6-dev libbz2-dev libgmp-dev libmagickwand-dev zlib1g-dev libicu-dev jpegoptim optipng pngquant gifsicle locales zip vim unzip git curl gnupg libcurl4-openssl-dev pkg-config libssl-dev libzip-dev  -q -y --force-yes

#nginx
sudo apt install nginx -q -y --force-yes
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'
sudo chmod -R 755 /var/www/html/*
sudo nginx -v

#certbot
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo rm -rf /usr/bin/certbot
sudo ln -sf /snap/bin/certbot /usr/bin/certbot

#node
sudo curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn nodejs -q -y --force-yes
node -v

#mariadb
sudo apt install mariadb-server mariadb-client -q -y --force-yes
mysql_secure_installation <<EOF
y
secret
secret
y
y
y
y
EOF
mysql -u root <<EOF
DROP DATABASE api;
CREATE DATABASE api;
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('secret');
exit
EOF

#pm2
npm install pm2@latest -g