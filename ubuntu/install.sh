#!/usr/bin/env sh

##
# Works in ubuntu 21.10

# Logging in admin
printf '\e[1;31m Entrando como usuário root \e[0m\n'
sudo su

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -q -y --force-yes && sudo apt-get upgrade -q -y --force-yes && sudo apt-get dist-upgrade -q -y --force-yes

printf '\e[1;31m Buscando o arquivo id_rsa.pub \e[0m\n'
[ -f ~/.ssh/id_rsa.pub ] && echo '\e[1;31m Encontrado \e[0m\n' || echo '\e[1;31m Não encontrado \e[0m\n'
[ -f ~/.ssh/id_rsa.pub ] && echo '\e[1;31m ... \e[0m\n' || ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

# Loggout admin
printf '\e[1;31m Saindo de usuário root \e[0m\n'
exit