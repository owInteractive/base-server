# Base Server - OW Interactive

## Sobre a OW Interactive

Fazemos parte do universo digital, focada em criar e desenvolver experiências interativas, integrando planejamento, criatividade e tecnologia.

Conheça mais sobre nós em: [OW Interactive - Quem somos](http://www.owinteractive.com/quem-somos/).

## Sobre esse script

É um script que visa automatizar e instalar de forma mais rápida um servidor dedicado, de uma aplicação em NODE.JS

## Pré-requisitos

- Servidor na nuvem;
- Acesso sudo e SSH ao servidor;
- Projeto configurado no bitbucket;

## Requisitos

- Ubuntu 21.10

## Como rodar

Primeiro você roda na linha de comando o arquivo de configuração de instalação de todas as programas, linguagens e cli's do projeto

`curl -sL https://raw.githubusercontent.com/owInteractive/base-server/master/ubuntu/install.sh -H "Cache-Control: no-cache, no-store, must-revalidate" | sh`

Depois é necessário rodar o configurador do projeto

`curl -sL https://raw.githubusercontent.com/owInteractive/base-server/master/ubuntu/project.sh -H "Cache-Control: no-cache, no-store, must-revalidate" | sh`

Depois é só correr para o abraço, e configurar o certbot se necessário.

![Brooklyn Nine-Nine](https://media.giphy.com/media/l4JySAWfMaY7w88sU/giphy.gif "Brooklyn Nine-Nine")
