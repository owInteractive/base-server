#!/usr/bin/env sh

##
# Works in ubuntu 21.10

# Logging in admin
printf '\e[1;31m Entrando como usuário root \e[0m\n'
sudo su

printf '\e[1;31m Fazendo update do S.O \e[0m\n'
sudo apt-get update -y && sudo apt-get upgrade -y

# Loggout admin
printf '\e[1;31m Saindo de usuário root \e[0m\n'
exit