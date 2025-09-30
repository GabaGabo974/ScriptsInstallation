#!/bin/bash

set -e

echo " Mise à jour du système..."
apt update && apt upgrade -y

echo " Installation des paquets nécessaires pour FOG..."
apt install -y \
  git apache2 php php-mysql php-cli php-curl php-gd php-mbstring \
  php-xml php-json php-bcmath php-intl \
  mariadb-server mariadb-client \
  curl net-tools wget tar gzip xz-utils \
  nfs-kernel-server tftpd-hpa syslinux pxelinux

echo " Préparation de Debian 12 terminée."
