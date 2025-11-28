#!/bin/bash

# Define the dash_install function
function dash_install {
    ## Install the DTMF Controls
    echo -e "$(date)" "${GREEN} #### Installazione dei controlli DTMF #### ${NORMAL}" >> /var/log/install.log > /dev/null
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
    DASHBOARD_USER=$(whiptail --title "Nome utente della dashboard" --inputbox "Inserisci il nome utente della dashboard:" 8 78 svxlink 3>&1 1>&2 2>&3)

    if [ $? -eq 0 ]; then
        echo "Il nome utente inserito è: $DASHBOARD_USER"
    else
        echo "Hai annullato l'inserimento del nome utente."
        exit 1
    fi

    while true; do
    DASHBOARD_PASSWORD=$(whiptail --title "Password della dashboard" --passwordbox "Inserisci la password della dashboard:" 8 78 3>&1 1>&2 2>&3)

    # Check if user cancelled
    if [ $? -ne 0 ]; then
        echo "Hai annullato l'inserimento della password."
        exit 1
    fi

    # Ask for password confirmation
    CONFIRM_PASSWORD=$(whiptail --title "Conferma password" --passwordbox "Conferma la password della dashboard:" 8 78 3>&1 1>&2 2>&3)

    if [ $? -ne 0 ]; then
        echo "Hai annullato la conferma della password."
        exit 1
    fi

    # Check if passwords match
    if [ "$DASHBOARD_PASSWORD" == "$CONFIRM_PASSWORD" ]; then
        echo "Password confermata."
        break
    else
        whiptail --title "Errore" --msgbox "Le password non corrispondono. Riprova." 8 78
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
    echo "Il file di autenticazione $AUTH_FILE è stato creato e configurato."

    ## change ownership of all files
    sudo find /var/www/html -exec chown svxlink:svxlink {} +

    echo "La proprietà dei file in /var/www/html è stata impostata su svxlink:svxlink"

    ## create /home/pi/scripts and cleanup.sh if missing
    SCRIPT_DIR="/home/pi/scripts"
    CLEANUP_SCRIPT="$SCRIPT_DIR/cleanup.sh"

    if [ ! -d "$SCRIPT_DIR" ]; then
        mkdir -p "$SCRIPT_DIR"
        echo "La directory $SCRIPT_DIR è stata creata"
    fi

    if [ ! -f "$CLEANUP_SCRIPT" ]; then
        cat << EOF > "$CLEANUP_SCRIPT"
#!/bin/bash
DIR="/var/www/html/backups"

if [ -d "\$DIR" ]; then
    find "\$DIR" -type f -mtime +7 -exec rm -f {} \;
else
    echo "La directory \$DIR non esiste."
fi
EOF

        sudo chmod +x "$CLEANUP_SCRIPT"
        echo "Creato e reso eseguibile $CLEANUP_SCRIPT."
    fi

    ## ensure cleanup.sh is in root crontab
    CRON_JOB="01 00 * * * /home/pi/scripts/cleanup.sh"
    (sudo crontab -l 2>/dev/null; echo "$CRON_JOB") | sort -u | sudo crontab -

    echo "Verificata l'esistenza della voce di crontab per $CLEANUP_SCRIPT."
}
