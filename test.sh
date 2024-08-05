#!/bin/bash
    CHOICE=$(whiptail --title "Select Time Format" --radiolist \
    "Choose your preferred time format:" 15 50 2 \
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
        echo "Configuration file not found: $CONFIG_FILE"
        return 1
    fi

