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

read -p "Endereço do projeto: " site
echo "$site"

read -p "Nome do projeto no bitbucket sem http(s): " project
echo "$project"

rm -rf /var/www/html/$project
git clone git@bitbucket.org:owinteractive/$project.git /var/www/html/$site
cp /var/www/html/$site/.env.example .env