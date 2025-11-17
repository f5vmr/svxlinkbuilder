#!/bin/bash

# Define the dash_install function
function dash_install {
    ## Install the DTMF Controls
    echo -e "$(date)" "${GREEN} #### A Instalar os controlos do DTMF #### ${NORMAL}" | sudo tee -a  /var/log/install.log
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
    DASHBOARD_USER=$(whiptail --title "Utilizador do Painel" --inputbox "Introduz o utilizador para o Painel:" 8 78 svxlink 3>&1 1>&2 2>&3)

    if [ $? -eq 0 ]; then
        echo "Utilizador do Painel Introduzido: $DASHBOARD_USER"
    else
        echo "Inserção de utilizador cancelada."
        exit 1
    fi

    while true; do
    DASHBOARD_PASSWORD=$(whiptail --title "Password do Painel" --passwordbox "Introduz a Password para o Painel:" 8 78 3>&1 1>&2 2>&3)

    # Check if user cancelled
    if [ $? -ne 0 ]; then
        echo "Inserção da password cancelada."
        exit 1
    fi

    # Ask for password confirmation
    CONFIRM_PASSWORD=$(whiptail --title "Confirma a Password" --passwordbox "Por Favor confirma a password do Painel:" 8 78 3>&1 1>&2 2>&3)

    if [ $? -ne 0 ]; then
        echo "Inserção da password cancelada."
        exit 1
    fi

    # Check if passwords match
    if [ "$DASHBOARD_PASSWORD" == "$CONFIRM_PASSWORD" ]; then
        echo "Password confirmada."
        break
    else
        whiptail --title "Error" --msgbox "As Passwords não são iguais, tenta novamente." 8 78
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
    echo "O ficheiro de autenticação $AUTH_FILE foi criado e configurado."

    ## change ownership of all files
    sudo find /var/www/html -exec chown svxlink:svxlink {} +

    echo "A propriedade dos ficheiros /var/www/html foram atribuidas a svxlink:svxlink"

    ## create /home/pi/scripts and cleanup.sh if missing
    SCRIPT_DIR="/home/pi/scripts"
    CLEANUP_SCRIPT="$SCRIPT_DIR/cleanup.sh"

    if [ ! -d "$SCRIPT_DIR" ]; then
        mkdir -p "$SCRIPT_DIR"
        echo "Diretoria Criada $SCRIPT_DIR"
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
