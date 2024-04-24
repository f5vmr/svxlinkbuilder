#!/bin/bash
function soundcard {

card=false

## Run lsusb and filter the output to check for a USB sound card
lsusb_output=$(lsusb)

## Check if the USB sound card is present in the lsusb output
if echo "$lsusb_output" | grep -q "C-Media"; 
then
    echo "USB carte-son est presente."
    USB_sound_card_present=true
else
    echo "USB carte-son n'est pas presente."
    USB_sound_card_present=false
fi

## Assign the presence of the USB sound card to a variable
if [[ "$USB_sound_card_present" = true ]]
then
    ## If USB sound card is present, assign some value to a variable
    sound_card_variable="C-Media USB Sound Device"
    card=true
else
    ## If USB sound card is not present, assign another value to the variable
    sound_card_variable="Not present"
    card=false
fi

## Print the assigned variable value
echo "Variable assigned: $sound_card_variable"

    SOUND_OPTION=$(whiptail --title "USB Soundcard" --menu "Selectionner des options dessous." 12 78 4 \
        "1" "Modifié pour Tx et Rx" \
        "2" "Modifié uniquement pour Tx" \
        "3" "Sans modification (utiliser GPIOD contrôler le Squelch et PTT )" 3>&1 1>&2 2>&3)      
    if [[ "$SOUND_OPTION" = "1" ]] 
    then
    HID=true
    GPIOD=false
    card=true
    ## No need to play with the GPIOD
    elif [[ "$SOUND_OPTION" = "2" ]] 
    then
    HID=true
    GPIOD=true
    card=true
    ## still need to set the HID for Transmit
    elif [[ "$SOUND_OPTION" = "3" ]] 
    then
    HID=false
    GPIOD=true
    card=false
    ## still need to set GPIOD for Transmit and Receive
    else 
    echo "Option pas valide"
    fi
    echo "HID is set to $HID"
    echo "GPIOD is set to $GPIOD"
    if [[ "$HID" = true ]] 
    then 
#### updates the udev rules for the USB sound card ####
    if [[ "$card" = true ]] 
    then
    echo "Ok, allons y - changer les règles udev pour le USB sound card"
               sudo cp /home/pi/svxlinkbuilder/addons/cm-108.rules /etc/udev/rules.d/
               sudo udevadm control --reload-rules
               sudo udevadm trigger
                
    else
    echo "ok, donc, je ne fait pas de changements"           
    fi               
fi
    echo -e "$(date)" "${GREEN}Audio mis à jour, carte-son factice inclu pour Darkice complètés.${NORMAL}" | tee -a /var/log/install.log
				
}