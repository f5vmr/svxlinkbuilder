#!/bin/bash
#### Apache2 Server ####
function install_apache2_server {
    sudo apt-get install apache2 php8.2-common php8.2-fpm php8.2-curl php8.2-dev php8.2-gd php-imagick \
        php-memcached php8.2-pspell php8.2-snmp php8.2-sqlite3 php8.2-xmlrpc \
        php8.2-xml php-pear php-ssh2 php8.2-cli php8.2-zip sqlite3 -y
    sed -i's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=svxlink/g' /etc/apache2/envars
    sed -i's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=svxlink/g' /etc/apache2/envars
    sudo systemctl restart apache2
    sudo systemctl enable apache2
    sudo rm -r /var/www/html
    sudo git clone https://github.com/f5vmr/SVXLink-Dash-V2.git /var/www/html
}




