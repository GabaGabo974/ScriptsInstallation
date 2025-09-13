#!/bin/bash

# =========================================
# Script d installation automatique WordPress
# Debian 13 - BTS SIO
# =========================================

# Variables
DB_NAME="wordpress_db"
DB_USER="wp_user"
DB_PASS="wp_pass123"
WP_DIR="/var/www/html/wordpress"

echo "=== Mise a jour du systeme ==="
apt update -y && apt upgrade -y

echo "=== Installation Apache, MariaDB, PHP ==="
apt install -y apache2 mariadb-server php php-mysql php-xml php-mbstring php-curl php-zip wget unzip tar

echo "=== Activation Apache ==="
systemctl enable apache2
systemctl start apache2

echo "=== Securisation MariaDB ==="
systemctl enable mariadb
systemctl start mariadb

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

echo "=== Installation terminee ==="
echo "Ouvrez votre navigateur sur http://<IP_SERVEUR>/ pour finir la configuration."
