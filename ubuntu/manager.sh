#/bin/bash

##
# Works in ubuntu 21.10

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes

printf '\e[1;31m Buscando o arquivo id_rsa.pub \e[0m\n'
[ -f ~/.ssh/id_rsa.pub ] && echo '\e[1;31m Encontrado \e[0m\n' || echo '\e[1;31m Não encontrado \e[0m\n'
[ -f ~/.ssh/id_rsa.pub ] && echo '\e[1;31m ... \e[0m\n' || ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

printf '\e[1;31m Copiei e cole essa chave no repositorio remoto nas configurações do bitbucket \e[0m\n'
cat ~/.ssh/id_rsa.pub

# manager-v3.owinteractive.com
read -p "Endereço do projeto  sem http(s) Ex:manager-v3.owinteractive.com : " site
echo "$site"

# manager-vue3.base.com
read -p "Nome do projeto no bitbucket Ex:manager-vue3.base.com : " project
echo "$project"

rm -rf /var/www/html/$project
rm -rf /var/www/html/$site
git clone git@bitbucket.org:owinteractive/$project.git /var/www/html/$site
cp /var/www/html/$site/.env.example /var/www/html/$site/.env
cd /var/www/html/$site/
sudo sed -i 's/localhost:3333/api-v3.owinteractive.com/g' .env
npm i -g @quasar/cli
npm install
quasar build -m pwa
cd ~/

sudo touch /etc/nginx/conf.d/$site.conf
sudo echo "server {
    listen 80;
    server_name $site;

    root /var/www/html/$site/dist/pwa;
    index index.html;

    location ~/.well-known {
        allow all;
    }

    location / {
      root /var/www/html/$site/dist/pwa;
      try_files \$uri /index.html;
    }

    location ~*  \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 1d;
    }

    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    add_header Strict-Transport-Security 'max-age=63072000; includeSubdomains';
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    access_log off;

    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_send_timeout 300;
    client_max_body_size 10M;
}" > /etc/nginx/conf.d/$site.conf
sudo nginx -t
sudo systemctl restart nginx

cd ~/