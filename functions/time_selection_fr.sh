function timeselect {
    # Present the whiptail dialog and capture the user's choice
    CHOICE=$(whiptail --title "Sélectionnez le format de l'heure" --radiolist \
    "Format horaire préféré:" 15 50 2 \
    "12" "12 Heures" ON \
    "24" "24 Heures" OFF 3>&1 1>&2 2>&3)
    
    # Check if user canceled the dialog
    if [ $? -ne 0 ]; then
        echo "Annulation de la fenêtre"
        return 1
    fi

    # Update the TIME_FORMAT in the configuration file
    CONFIG_FILE="/etc/svxlink/svxlink.conf"
    
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s/^TIME_FORMAT=.*/TIME_FORMAT=\"$CHOICE\"/" "$CONFIG_FILE"
        echo "${GREEN} TIME_FORMAT updated to $CHOICE in $CONFIG_FILE. ${WHITE}" | sudo tee
    else
        echo "Fichier de configuration non trouvé: $CONFIG_FILE"
        return 1
    fi
}
