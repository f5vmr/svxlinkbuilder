function timeselect {
    # Present the whiptail dialog and capture the user's choice
    CHOICE=$(whiptail --title "Seleccionar formato de hora" --radiolist \
    "Formato de hora preferido:" 15 50 2 \
    "12" "Hora de reloj de 12 horas" ON \
    "24" "Hora de reloj de 24 horas" OFF 3>&1 1>&2 2>&3)
    
    # Check if user canceled the dialog
    if [ $? -ne 0 ]; then
        echo "Dialog canceled."
        return 1
    fi

    # Update the TIME_FORMAT in the configuration file
    CONFIG_FILE="/etc/svxlink/svxlink.conf"
    
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s/^TIME_FORMAT=.*/TIME_FORMAT=\"$CHOICE\"/" "$CONFIG_FILE"
        echo "${GREEN} TIME_FORMAT updated to $CHOICE in $CONFIG_FILE. ${WHITE}" | sudo tee -a /var/log/install.log > dev/null
    else
        echo "Configuration file not found: $CONFIG_FILE"
        return 1
    fi
}
