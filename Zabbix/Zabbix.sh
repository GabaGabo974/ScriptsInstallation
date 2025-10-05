echo "=== Installation serveur Zabbix, agent et frontend ==="

wget https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb
dpkg -i zabbix-release_latest_7.2+debian12_all.deb
apt update
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent default-mysql-server

echo "=== Création de la base de donnée ==="
read -p "Nom de la base de donnée : " DB_NAME
read -p "Nom de l'utilisateur de la base de données : " DB_USER
read -p "Mot de passe de l'utilisateur : " DB_PASS

mysql -u root <<EOF
    CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
    FLUSH PRIVILEGES;
    set global log_bin_trust_function_creators = 1;
EOF

echo "=== Importation du schéma initial et des données ==="
sudo zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u $DB_USER -p$DB_PASS -D $DB_NAME
mysql -u root <<EOF
    set global log_bin_trust_function_creators = 0;
EOF

sed -i "s/'# DBPassword='/'DBPassword=$DB_PASS'/g" /etc/zabbix/zabbix_server.conf