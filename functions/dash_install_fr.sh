#!/bin/bash
## here we install the dashboard to /var/www


function install_dash {
    ## install the dashboard
    cd /var/www/
    sudo rm -r html
    sudo git clone https://github.com/f5vmr/SVXLink-Dash-V2 html
    ## change ownership of the dashboard
    sudo chown -R svxlink:svxlink html
    ## change permissions of the dashboard
    sudo chmod -R 755 html
    ## change Apache2 permissions
    cd /etc/apache2/
    sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=svxlink/g' envvars
    sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=svxlink/g' envvars
    cd /usr/lib/systemd/system/
    sed -i 's/PrivateTmp=true/PrivateTmp=false/g' apache2.service
    ## restart Apache2
    sudo systemctl daemon-reload
    sudo systemctl restart apache2.service
    ## Dashboard Permissions
    whiptail --title "Permissions Tableau de Bord" --yesno "Ajouter les autorisations Tableau?" 8 78
    if [ $? -eq "0" ] 
    then
    ## add permissions to the dashboard
    sudo chmod -R 777 /var/www/html/include/config.inc.php
    dashboard_user=$(whiptail --title "Dashboard User" --inputbox "Selectionnez le nom d'utilisateur du tableau - unique" 8 78 svxlink 3>&1 1>&2 2>&3)
    dashboard_pass=$(whiptail --title "Dashboard Password" --passwordbox "Entrez le mot-pass de l'utilisateur du tableau" 8 78 3>&1 1>&2 2>&3)
    sudo sed -i "s/\"svxlink\"/\"$dashboard_user\"/g" /var/www/html/include/config.inc.php
    sudo sed -i "s/\"password\"/\"$dashboard_pass\"/g" /var/www/html/include/config.inc.php
    ## permissions added

## Define the lines to add to sudoers
#sudo mkdir /etc/sudoers.d/
sudo cp -f /home/pi/svxlinkbuilder/addons/svxlink /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/svxlink
## Check sudoers file syntax
 sudo visudo -c

## Check if syntax check passed

    echo "Lignes ajoutées aux sudoers avec succès."
else
    echo "Error: Failed to add lines to sudoers. Restoring backup."
 fi
## Add permissions to Apache2

## Determine IP address of eth0 and Wifi interface


}