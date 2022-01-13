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

# api-v3.owinteractive.com
read -p "Endereço do projeto  sem http(s) Ex:api-v3.owinteractive.com : " site
echo "$site"

# api-nest.base.com
read -p "Nome do projeto no bitbucket Ex:api-nest.base.com : " project
echo "$project"

rm -rf /var/www/html/$project
rm -rf /var/www/html/$site
git clone git@bitbucket.org:owinteractive/$project.git /var/www/html/$site
cp /var/www/html/$site/.env.example /var/www/html/$site/.env
cd /var/www/html/$site/
sudo sed -i 's/owdev/root/g' .env
sudo sed -i 's/base_api_db/localhost/g' .env
npm install
cd ~/

sudo dd if=/dev/zero of=/swapfile count=1024 bs=1MiB
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

sudo touch /etc/nginx/conf.d/$site.conf
sudo echo "server {
    listen 80;
    server_name $site;

    root /var/www/html/$site;
    index index.html;

    location ~/.well-known {
        allow all;
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

    location / {
        proxy_pass http://localhost:3333;
        proxy_http_version 1.1;
        proxy_set_header Connection 'upgrade';
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 365d;
    }
}" > /etc/nginx/conf.d/$site.conf
sudo nginx -t
sudo systemctl restart nginx

cd /var/www/html/$site/
mysql -u root -psecret <<EOF
DROP DATABASE api;
CREATE DATABASE api;
COMMIT;
exit
EOF
node -r tsconfig-paths/register -r ts-node/register ./node_modules/typeorm-seeding/dist/cli.js -r src/config -n type-orm.module.ts -s MainSeeder seed
npm run build
pm2 delete all
pm2 start dist/main.js --name "api"
cd ~/