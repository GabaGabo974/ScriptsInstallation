echo "1. Installation complete (LAMP & GLPI)"
echo "2. Installation de MariaDB"
echo "3. Installation de GLPI"

read -p "De quoi avez vous besoin ? : " choix

if [ "$choix" = "1" ]; then
    #Installation des paquets
    sudo apt update -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update

    sudo apt install -y apache2 mariadb-server libapache2-mod-php8.2 \
    php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-imap \
    php8.2-ldap php8.2-mysql php8.2-xml php8.2-mbstring php8.2-bcmath \
    php8.2-intl php8.2-zip php8.2-bz2 php8.2-soap


    apt update -y && apt upgrade -y
    systemctl restart apache2
    #Mariadb
    mysql_secure_installation <<EOF
    y
    root
    root
    y
    y
    y
    y
EOF

    BDD="glpi"
    UTILISATEUR="glpi_user"
    MDP="mdp"

    mysql -u root -p'root' -e "CREATE DATABASE $BDD;"
    mysql -u root -p'root' -e "CREATE USER '$UTILISATEUR'@'localhost' IDENTIFIED BY '$MDP';"
    mysql -u root -p'root' -e "GRANT ALL PRIVILEGES ON $BDD.* TO '$UTILISATEUR'@'localhost';"
    mysql -u root -p'root' -e "FLUSH PRIVILEGES"

    #Installation & décompression de GLPI

    cd /var/www/html
    wget https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz
    tar -xzvf glpi-10.0.18.tgz
    chown -R www-data:www-data /var/www/html/glpi/files
    chmod -R 777 /var/www/html/glpi/files
    rm glpi-10.0.18.tgz -Rf
    systemctl restart apache2

    
    read -p "Entre l'adresse IP de l'hôte : " hote
    read -p "Entre le nom de la base de données: " bdd
    read -p "Entre l'utilisateur : " utilisateur
    read -p "Entre le mot de passe de l'utilisateur: " mdp


    # [GLPI] Montage de la base de données
    php /var/www/html/glpi/bin/console db:install \
    -H $hote \
    -d $bdd \
    -u $utilisateur \
    -p $mdp \
    -L fr_FR
    --no-interaction
    chown -R www-data:www-data /var/www/html/glpi/files/_log
    #cd /var/www/html/glpi/
    #php bin/console system:check_requirements
elif [ "$choix" = 2 ]; then
    apt install -y apache2 mariadb-server
    mysql_secure_installation <<EOF
    y
    root
    root
    y
    y
    y
    y
EOF

    read -p "Souhaitez-vous créer un utilisateur ? [o/n] " choix
    if [ "$choix" = "o" ]; then
        read -p "Entre le nom ou l'adresse IP de l'hôte : " host
        read -p "Entrez le nom de l'utilisateur, ainsi que son hôte (@) : " user
        read -p "Entrez le mot de passe de l'utilisateur : " mdp
        read -p "Entrez le nom de la base de donnee : " bdd

        mysql -u root -p'root' -e "CREATE DATABASE $bdd;"
        echo "Base de données $bdd créée"

        mysql -u root -p'root' -e "CREATE USER '$user'@'$host' IDENTIFIED BY '$mdp';"
        echo "Utilisateur $user créé"

        mysql -u root -p'root' -e "GRANT ALL PRIVILEGES ON $bdd.* TO '$user'@'$host';"
        mysql -u root -p'root' -e "FLUSH PRIVILEGES"
    else
        echo "Installation terminée"
    fi
elif [ "$choix" = 3 ]; then
    #Installation des paquets
    sudo apt update -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update

    sudo apt install -y apache2 mariadb-server libapache2-mod-php8.2 \
    php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-imap \
    php8.2-ldap php8.2-mysql php8.2-xml php8.2-mbstring php8.2-bcmath \
    php8.2-intl php8.2-zip php8.2-bz2 php8.2-soap


    apt update -y && apt upgrade -y
    systemctl restart apache2

    cd /var/www/html
    wget https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz
    tar -xzvf glpi-10.0.18.tgz
    chown -R www-data:www-data /var/www/html/glpi/files
    chmod -R 777 /var/www/html/glpi/files
    rm glpi-10.0.18.tgz -Rf
    systemctl restart apache2

    read -p "Entre l'adresse IP de l'hôte : " hote
    read -p "Entre le nom de la base de données: " bdd
    read -p "Entre l'utilisateur : " utilisateur
    read -p "Entre le mot de passe de l'utilisateur: " mdp


    # [GLPI] Montage de la base de données
    php /var/www/html/glpi/bin/console db:install \
    -H $hote \
    -d $bdd \
    -u $utilisateur \
    -p $mdp \
    -L fr_FR
    --no-interaction
    chown -R www-data:www-data /var/www/html/glpi/files/_log
    #cd /var/www/html/glpi/
    #php bin/console system:check_requirements
fi