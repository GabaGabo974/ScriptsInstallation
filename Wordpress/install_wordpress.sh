#!/bin/bash

# Variables
read -p "Nom de la base de données : " DB_NAME
read -p "Nom de l'utilisateur de la base de données : " DB_USER
read -p "Mot de passe de l'utilisateur : " DB_PASS

WP_DIR="/var/www/html/wordpress"
IPV4=$(ip -4 addr show $(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -1) | grep -oP '(?<=inet\s)\d+(\.\d+){3}')


echo "=== Mise a jour du systeme ==="
apt update -y && apt upgrade -y

echo "=== Installation LAMP & WP-CLI ==="
apt install -y apache2 mariadb-server php php-mysql php-xml php-mbstring php-curl php-zip wget unzip tar curl sendmail
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Creation BDD WordPress
echo "=== Creation base de donnees WordPress ==="
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "=== Telechargement WordPress ==="
wget -q https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /tmp/

echo "=== Installation fichiers WordPress ==="
rm -rf ${WP_DIR}
mv /tmp/wordpress ${WP_DIR}

echo "=== Droits sur WordPress ==="
chown -R www-data:www-data ${WP_DIR}
chmod -R 755 ${WP_DIR}

echo "=== Configuration Apache ==="
cat <<EOF >/etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot ${WP_DIR}
    <Directory ${WP_DIR}>
        AllowOverride All
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/wordpress_error.log
    CustomLog \${APACHE_LOG_DIR}/wordpress_access.log combined
</VirtualHost>
EOF

a2ensite wordpress
a2enmod rewrite
systemctl reload apache2

echo "=== Configuration de Wordpress ==="

cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
cd /var/www/html/wordpress/
sed -i "s/'database_name_here'/'$DB_NAME'/g" wp-config.php
sed -i "s/'username_here'/'$DB_USER'/g" wp-config.php
sed -i "s/'password_here'/'$DB_PASS'/g" wp-config.php

cd ..
sudo -u www-data bash -c "wp core install --url=\"http://$IPV4/wordpress\" --title=\"TestScriptWP\" --admin_user=\"admin\" --admin_password=\"p@ssW0rd\" --admin_email=\"test@machin.com\" --path=\"wordpress\""