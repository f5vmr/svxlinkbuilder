#!/bin/bash

# Define the dash_install function
function dash_install {
    ## install the dashboard
    cd /var/www/ || exit 1
    sudo rm -r html
    sudo git clone https://github.com/f5vmr/SVXLink-Dash-V2 html
    ## change ownership of the dashboard
    sudo chown -R svxlink:svxlink html
    ## change permissions of the dashboard
    sudo chmod -R 775 html
    ## change Apache2 permissions
    cd /etc/apache2/ || exit 1
    sudo sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=svxlink/g' envvars
    sudo sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=svxlink/g' envvars
    cd /usr/lib/systemd/system/ || exit 1
    sudo sed -i 's/PrivateTmp=true/PrivateTmp=false/g' apache2.service
    ## restart Apache2
    sudo systemctl daemon-reload
    sudo systemctl restart apache2.service
    ## Dashboard Permissions

    # Prompt for the dashboard username using whiptail
    DASHBOARD_USER=$(whiptail --title "Permisos del Panel" --inputbox "Ingrese el nombre de usuario para el panel" 8 78 svxlink 3>&1 1>&2 2>&3)

    # Check if the user pressed Cancel or entered an empty input
    if [ $? -eq 0 ]; then
        echo "Usuarior del Panel: $DASHBOARD_USER"
    else
        echo "User cancelled the username input."
        exit 1
    fi

    # Prompt for the dashboard password using whiptail
    DASHBOARD_PASSWORD=$(whiptail --title "Contraseña del panel" --passwordbox "Ingrese la contraseña del tablero:" 8 78 3>&1 1>&2 2>&3)

    # Check if the user pressed Cancel or entered an empty input
    if [ $? -eq 0 ]; then
        echo "User entered password: [hidden]"
    else
        echo "User cancelled the password input."
        exit 1
    fi

    # Update the config file with the provided username and password
    CONFIG_FILE="/var/www/html/include/config.inc.php"
    if [ -f "$CONFIG_FILE" ]; then
        sudo sed -i "s/define(\"PHP_AUTH_USER\", \".*\");/define(\"PHP_AUTH_USER\", \"$DASHBOARD_USER\");/" "$CONFIG_FILE"
        sudo sed -i "s/define(\"PHP_AUTH_PW\", \".*\");/define(\"PHP_AUTH_PW\", \"$DASHBOARD_PASSWORD\");/" "$CONFIG_FILE"
        echo "The config file $CONFIG_FILE has been updated with the new username and password."
    else
        echo "Error: Config file $CONFIG_FILE does not exist. Exiting."
        exit 1
    fi

    # Change ownership of all files in /var/www/html 
    sudo find /var/www/html -exec sudo chown svxlink:svxlink {} +

    # Inform the user that the ownership change was successful
    echo "Ownership of files in /var/www/html has been changed to svxlink:svxlink, except for the script itself."

    # New section to create /home/pi/scripts and cleanup.sh
    SCRIPT_DIR="/home/pi/scripts"
    CLEANUP_SCRIPT="$SCRIPT_DIR/cleanup.sh"

    # Check if the script directory exists, if not, create it
    if [ ! -d "$SCRIPT_DIR" ]; then
        mkdir -p "$SCRIPT_DIR"
        echo "Created directory $SCRIPT_DIR"
    fi

    # Check if the cleanup.sh script does not exist
    if [ ! -f "$CLEANUP_SCRIPT" ]; then
        # Here document to create the cleanup.sh script with the specified content
        cat << EOF > "$CLEANUP_SCRIPT"
#!/bin/bash

# Directory to be cleaned (this is redundant here, as it's already set above)
DIR="/var/www/html/backups"

# Check if directory exists
if [ -d "\$DIR" ]; then
    # Find and delete files older than 7 days
    find "\$DIR" -type f -mtime +7 -exec rm -f {} \;
else
    echo "Directory \$DIR does not exist."
fi
EOF

        # Make the cleanup.sh script executable
        sudo chmod +x "$CLEANUP_SCRIPT"
        echo "Created and made $CLEANUP_SCRIPT executable."
    fi

    # Check and add the cleanup.sh script to the sudo crontab if not already present
    CRON_JOB="01 00 * * * /home/pi/scripts/cleanup.sh"
    ( sudo crontab -l | grep -q "$CRON_JOB" ) || ( sudo crontab -l; echo "$CRON_JOB" ) | sudo crontab -

    # Inform the user that the crontab entry has been added if it was not present
    echo "Ensured that the crontab entry for $CLEANUP_SCRIPT exists."
}


