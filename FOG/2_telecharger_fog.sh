#!/bin/bash

set -e

echo " Création du dossier de travail..."
mkdir -p ~/fog
cd ~/fog

echo " Téléchargement de FOG Project depuis GitHub..."
if [ ! -d "fogproject" ]; then
  git clone https://github.com/FOGProject/fogproject.git
fi

echo " Création du script d'automatisation..."
cat << 'EOF' > ~/fog/3_installer_fog_auto.sh
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
EOF

chmod +x ~/fog/3_installer_fog_auto.sh

echo " Téléchargement et génération des fichiers terminés."
