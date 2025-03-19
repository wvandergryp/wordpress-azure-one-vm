#!/usr/bin/env bash

echo "Allocating a memory swap file..."
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sleep 120

sudo apt-get update -y
sudo apt update -y

echo "Starting MariaDB install process..."
sudo apt -y install mariadb-server

echo "Applying post-MariaDB install configuration changes..."
sudo sed -i s/127.0.0.1/0.0.0.0/g /etc/mysql/mariadb.conf.d/50-server.cnf
sudo sed -i s/#skip-name-resolve/skip-name-resolve=on/g /etc/mysql/mariadb.conf.d/50-server.cnf
sudo service mariadb restart

sudo sh -c "echo 'mysql-server mysql-server/root_password password ${DB_ROOT_PASSWORD}' | debconf-set-selections"
sudo sh -c "echo 'mysql-server mysql-server/root_password_again password ${DB_ROOT_PASSWORD}' | debconf-set-selections"

sudo mysql --user=root --password=${DB_ROOT_PASSWORD} << EOFMYSQLSECURE
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOFMYSQLSECURE

sudo mysql --user=root --password="${DB_ROOT_PASSWORD}" << EOFWPCREATE
CREATE DATABASE ${WORDPRESS_DB_NAME};
CREATE USER '${WORDPRESS_DB_USER}'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_USER_PASSWORD}');
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'%';
FLUSH PRIVILEGES;
EOFWPCREATE

apt install -y apache2 \
            ghostscript \
            libapache2-mod-php \
            php \
            php-bcmath \
            php-curl \
            php-imagick \
            php-intl \
            php-json \
            php-mbstring \
            php-mysql \
            php-xml \
            php-zip

mkdir -p /srv/www
sudo chown www-data: /srv/www
curl --silent https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www
find /srv/www/ -type d -exec chmod 755 {} \;
find /srv/www/ -type f -exec chmod 644 {} \;
cat << EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
  DocumentRoot /srv/www/wordpress
  <Directory /srv/www/wordpress>
      Options FollowSymLinks
      Require all granted
      DirectoryIndex index.php
      Order allow,deny
      Allow from all
  </Directory>
  <Directory /srv/www/wordpress/wp-content>
      Options FollowSymLinks
      Order allow,deny
      Allow from all
  </Directory>
</VirtualHost>
EOF
a2enmod rewrite
systemctl reload apache2
sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php

sudo -u www-data sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/${DB_USERNAME}/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/${DB_USER_PASSWORD}/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/localhost/${DB_HOST}/' /srv/www/wordpress/wp-config.php

systemctl restart apache2