function timeselect {
    # Present the whiptail dialog and capture the user's choice
    CHOICE=$(whiptail --title "Seleciona o Time Format" --radiolist \
    "Escolhe o formato que pretendes:" 15 50 2 \
    "12" "12 Hour Clocktime" ON \
    "24" "24 Hour Clocktime" OFF 3>&1 1>&2 2>&3)
    
    # Check if user canceled the dialog
    if [ $? -ne 0 ]; then
        echo "Dialog canceled."
        return 1
    fi

    # Update the TIME_FORMAT in the configuration file
    CONFIG_FILE="/etc/svxlink/svxlink.conf"
    
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s/^TIME_FORMAT=.*/TIME_FORMAT=\"$CHOICE\"/" "$CONFIG_FILE"
        echo "${GREEN} TIME_FORMAT updated to $CHOICE in $CONFIG_FILE. ${WHITE}" | tee
    else
        echo "Ficheiro de configuração não encontrado: $CONFIG_FILE"
        return 1
    fi
}
