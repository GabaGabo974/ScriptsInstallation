#!/bin/bash

set -e

cd ~/fog/fogproject/bin || { echo " Dossier fogproject introuvable."; exit 1; }

echo " Lancement de l'installation automatique de FOG..."

sudo bash installfog.sh <<EOL
y
2

y
n

n
n

y
y
n
n
y
EOL

echo " Installation automatisée de FOG terminée."
