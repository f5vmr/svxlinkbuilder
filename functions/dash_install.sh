#!/bin/bash

# Define the dash_install function
function dash_install {
    ## install the dashboard
    cd /var/www/ || exit 1
    sudo rm -rf html
    sudo git clone https://github.com/f5vmr/SVXLink-Dash-V2 html
    
    ## change ownership and permissions
    sudo chown -R svxlink:svxlink html
    sudo chmod -R 775 html

    ## adjust Apache2 configuration
    cd /etc/apache2/ || exit 1
    sudo sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=svxlink/g' envvars
    sudo sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=svxlink/g' envvars

    cd /usr/lib/systemd/system/ || exit 1
    sudo sed -i 's/PrivateTmp=true/PrivateTmp=false/g' apache2.service

    ## restart Apache2
    sudo systemctl daemon-reload
    sudo systemctl restart apache2.service

    ## Dashboard Permissions
    DASHBOARD_USER=$(whiptail --title "Dashboard Username" --inputbox "Please enter your dashboard username:" 8 78 svxlink 3>&1 1>&2 2>&3)

    if [ $? -eq 0 ]; then
        echo "User entered username: $DASHBOARD_USER"
    else
        echo "User cancelled the username input."
        exit 1
    fi

    DASHBOARD_PASSWORD=$(whiptail --title "Dashboard Password" --passwordbox "Please enter your dashboard password:" 8 78 3>&1 1>&2 2>&3)

    if [ $? -eq 0 ]; then
        echo "User entered password: [hidden]"
    else
        echo "User cancelled the password input."
        exit 1
    fi

    CONFIG_FILE="/var/www/html/include/config.inc.php"
    if [ -f "$CONFIG_FILE" ]; then
        sudo sed -i "s/define(\"PHP_AUTH_USER\", \".*\");/define(\"PHP_AUTH_USER\", \"$DASHBOARD_USER\");/" "$CONFIG_FILE"
        sudo sed -i "s/define(\"PHP_AUTH_PW\", \".*\");/define(\"PHP_AUTH_PW\", \"$DASHBOARD_PASSWORD\");/" "$CONFIG_FILE"
        echo "The config file $CONFIG_FILE has been updated."
    else
        echo "Error: Config file $CONFIG_FILE does not exist. Exiting."
        exit 1
    fi

    ## change ownership of all files
    sudo find /var/www/html -exec chown svxlink:svxlink {} +

    echo "Ownership of files in /var/www/html set to svxlink:svxlink"

    ## create /home/pi/scripts and cleanup.sh if missing
    SCRIPT_DIR="/home/pi/scripts"
    CLEANUP_SCRIPT="$SCRIPT_DIR/cleanup.sh"

    if [ ! -d "$SCRIPT_DIR" ]; then
        mkdir -p "$SCRIPT_DIR"
        echo "Created directory $SCRIPT_DIR"
    fi

    if [ ! -f "$CLEANUP_SCRIPT" ]; then
        cat << EOF > "$CLEANUP_SCRIPT"
#!/bin/bash
DIR="/var/www/html/backups"

if [ -d "\$DIR" ]; then
    find "\$DIR" -type f -mtime +7 -exec rm -f {} \;
else
    echo "Directory \$DIR does not exist."
fi
EOF

        sudo chmod +x "$CLEANUP_SCRIPT"
        echo "Created and made $CLEANUP_SCRIPT executable."
    fi

    ## ensure cleanup.sh is in root crontab
    CRON_JOB="01 00 * * * /home/pi/scripts/cleanup.sh"
    (sudo crontab -l 2>/dev/null; echo "$CRON_JOB") | sort -u | sudo crontab -

    echo "Ensured crontab entry for $CLEANUP_SCRIPT exists."
}
