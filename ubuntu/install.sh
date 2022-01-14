#/bin/bash

##
# Works in ubuntu 21.10

lsb_release -a

sudo dd if=/dev/zero of=/swapfile count=1024 bs=1MiB
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes
sudo apt-get --purge autoremove -q -y --force-yes && sudo apt-get autoclean -q -y --force-yes
sudo rm -rf ~/.cache/thumbnails/*
sudo dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt-get -y purge
sudo apt-get install build-essential software-properties-common gcc g++ make wget procps libarchive-tools libaio1 libxml2-dev openssh-client libssh2-1-dev libssh2-1 libpng-dev libfreetype6-dev libbz2-dev libgmp-dev libmagickwand-dev zlib1g-dev libicu-dev jpegoptim optipng pngquant gifsicle locales zip vim unzip git curl gnupg libcurl4-openssl-dev pkg-config libssl-dev libzip-dev -q -y --force-yes
sudo apt install zsh -q -y --force-yes
sudo usermod -s /usr/bin/zsh $(whoami)

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
CREATE DATABASE IF NOT EXISTS api;
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('secret');
exit
EOF
sudo systemctl enable mariadb

#pm2
npm install pm2@latest -g

#redis
sudo apt install redis-server -q -y --force-yes
sudo systemctl enable redis.service
sudo systemctl start redis.service
sudo systemctl restart redis.service

#mailcatcher:1080
sudo apt-get install ruby ruby-dev ruby-all-dev sqlite3 libsqlite3-dev -y --force-yes
gem install mailcatcher
sudo rm -rf /etc/systemd/system/mailcatcher.service
echo '[Unit]
Description=MailCatcher
After=network.target
After=systemd-user-sessions.service
[Service]
Type=simple
Restart=on-failure
User=root
ExecStart=/usr/local/bin/mailcatcher --foreground --smtp-ip 0.0.0.0 --ip 0.0.0.0
[Install]
WantedBy=multi-user.target
' >> /etc/systemd/system/mailcatcher.service
sudo chmod 744 /etc/systemd/system/mailcatcher.service
sudo systemctl enable mailcatcher
sudo systemctl start mailcatcher

#mongodb
cd ~/
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update -q -y --force-yes
sudo apt-get install mongodb-org -q -y --force-yes
sudo systemctl enable mongod
sudo systemctl start mongod
sudo systemctl daemon-reload
