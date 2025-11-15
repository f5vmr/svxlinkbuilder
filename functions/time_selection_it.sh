function timeselect {
    # Present the whiptail dialog and capture the user's choice
    CHOICE=$(whiptail --title "Seleziona il formato dell’ora" --radiolist \
    "Seleziona il formato dell’ora che preferisci:" 15 50 2 \
    "12" "formato 12 ore" ON \
    "24" "formato 24 ore" OFF 3>&1 1>&2 2>&3)
    
    # Check if user canceled the dialog
    if [ $? -ne 0 ]; then
        echo "Operazione annullata."
        return 1
    fi

    # Update the TIME_FORMAT in the configuration file
    CONFIG_FILE="/etc/svxlink/svxlink.conf"
    
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s/^TIME_FORMAT=.*/TIME_FORMAT=\"$CHOICE\"/" "$CONFIG_FILE"
        echo "${GREEN} TIME_FORMAT aggiornato al $CHOICE in $CONFIG_FILE. ${WHITE}" | tee
    else
        echo "Impossibile trovare il file di configurazione: $CONFIG_FILE"
        return 1
    fi
}
