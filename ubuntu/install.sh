#!/usr/bin/env sh

##
# Works in ubuntu 21.10

# Logging in admin
printf '\e[1;31m Entrando como usuário root \e[0m\n'
sudo su

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes

printf '\e[1;31m Buscando o arquivo id_rsa.pub \e[0m\n'
[ -f ~/.ssh/id_rsa.pub ] && echo "Encontrado" || echo "Não encontrado"
[ -f ~/.ssh/id_rsa.pub ] && echo "Encontrado" || ssh-keygen -b 2048 -t rsa -f ~/.ssh -q -N ""

# Loggout admin
printf '\e[1;31m Saindo de usuário root \e[0m\n'
exit