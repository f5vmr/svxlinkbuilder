#!/bin/bash

# Define the dash_install function
function dash_install {
    ## Install the DTMF Controls
    echo -e "$(date)" "${GREEN} #### Installing DTMF Controls #### ${NORMAL}" | tee -a  /var/log/install.log
    sudo mkdir -p /var/run/svxlink
    sudo chown svxlink:svxlink /var/run/svxlink
    sudo chmod 775 /var/run/svxlink
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
# Create the systemd service only if it doesn't exist
SERVICE_FILE="/etc/systemd/system/svxlink-node.service"
if [ ! -f "$SERVICE_FILE" ]; then
    show_info "Creating svxlink-node.service..."
    sudo tee "$SERVICE_FILE" > /dev/null <<EOL
[Unit]
Description=SVXLink Node.js Server
After=network.target

[Service]
# Send logs directly to journald instead of syslog or files
StandardOutput=journal
StandardError=journal

# Ensure service restarts even after journal restarts or SIGHUPs
Restart=always
RestartSec=5

# Allow clean reloads (optional, useful if you add reload scripts later)
ExecReload=/bin/kill -HUP $MAINPID

# Give the process a few seconds to shut down gracefully
TimeoutStopSec=10
Type=simple
User=svxlink
Group=svxlink
ExecStart=/usr/bin/node /var/www/html/scripts/server.js
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOL

    show_info "Reloading systemd, enabling, and starting svxlink-node.service..."
    sudo systemctl daemon-reload
    sudo systemctl enable --now svxlink-node.service
    while true; do
    DASHBOARD_PASSWORD=$(whiptail --title "Dashboard Password" --passwordbox "Please enter your dashboard password:" 8 78 3>&1 1>&2 2>&3)

    # Check if user cancelled
    if [ $? -ne 0 ]; then
        echo "User cancelled the password input."
        exit 1
    fi

    # Ask for password confirmation
    CONFIRM_PASSWORD=$(whiptail --title "Confirm Password" --passwordbox "Please confirm your dashboard password:" 8 78 3>&1 1>&2 2>&3)

    if [ $? -ne 0 ]; then
        echo "User cancelled the password confirmation."
        exit 1
    fi

    # Check if passwords match
    if [ "$DASHBOARD_PASSWORD" == "$CONFIRM_PASSWORD" ]; then
        echo "Password confirmed."
        break
    else
        whiptail --title "Error" --msgbox "Passwords do not match. Please try again." 8 78
    fi
done

    AUTH_FILE="/etc/svxlink/dashboard.auth.ini"
    [ -f "$AUTH_FILE" ] && sudo cp "$AUTH_FILE" "${AUTH_FILE}.bak"

    sudo install -m 640 -o svxlink -g svxlink /dev/null "$AUTH_FILE"
    sudo tee "$AUTH_FILE" > /dev/null << EOF
[dashboard]
auth_user = "${DASHBOARD_USER:-svxlink}"
auth_pass = "${DASHBOARD_PASSWORD:-$(openssl rand -base64 12)}"
EOF
    echo "The authentication file $AUTH_FILE has been created and configured."

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
