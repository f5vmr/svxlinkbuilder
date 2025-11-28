#!/bin/bash
function soundcard {

# Check the sound cards present
sound_cards=$(cat /proc/asound/cards)

# Initialize variables to identify sound card types
usb_sound_card_detected=false
seeed_sound_card_detected=false
other_sound_card_detected=false

# Check for USB sound card
if echo "$sound_cards" | grep -q 'USB-Audio'; then
    echo "Carte son USB detectée:"
    echo "$sound_cards" | grep -A 1 'USB-Audio'
    usb_sound_card_detected=true
fi

# Check for Seeed 2-mic voice card
if echo "$sound_cards" | grep -q 'seeed-2mic-voicecard'; then
    echo "Carte Seeed 2-mic voice detectée:"
    echo "$sound_cards" | grep -A 1 'seeed-2mic-voicecard'
    seeed_sound_card_detected=true
fi

# Check for any other sound cards not explicitly identified by name and not Loopback
if echo "$sound_cards" | grep -q '[0-9] \[' && ! echo "$sound_cards" | grep -q 'Loopback' && ! $usb_sound_card_detected && ! $seeed_sound_card_detected; then
    echo "Autre carte son detectée:"
    echo "$sound_cards" | grep -v 'Loopback'
    other_sound_card_detected=true
fi

# If no sound card is detected or only Loopback card is detected
if ! $usb_sound_card_detected && ! $seeed_sound_card_detected && ! $other_sound_card_detected; then
    echo "Aucune carte son detectée ou juste la carte Loopback detectée." | sudo tee -a /var/log/install.log
    no_sound_card_detected
fi

# Handle based on detected sound card type
if $usb_sound_card_detected; then
    echo "Gestion des spécificités de la carte son USB..." | sudo tee -a /var/log/install.log
    usb_sound_card_detected
    # Add your specific handling code here for USB sound card
fi

if $seeed_sound_card_detected; then
    echo "Gestion des spécificités de la carte Seeed 2-mic..." | sudo tee -a /var/log/install.log
    seeed_sound_card_detected  
    # Add your specific handling code here for Seeed 2-mic voice card
fi

if $other_sound_card_detected; then
    echo "Gestion des spécificités des autres types de carte son..." | sudo tee -a /var/log/install.log
    other_sound_card_detected
    # Add your specific handling code here for other sound cards
fi

}
## Print the assigned variable value

function usb_sound_card_detected {
echo "Variable assigned: $sound_card_variable"

    SOUND_OPTION=$(whiptail --title "USB Soundcard" --menu "Selectionner les options ci-dessous." 12 78 4 \
        "1" "Modifié pour Tx et Rx (udev uniquement)" \
        "2" "Modifié uniquement pour Tx (udev TX & GPIOD RX)" \
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
    echo "HID est parametré sur $HID"
    echo "GPIOD est parametré sur $GPIOD"
    if [[ "$HID" = true ]] 
    then 
#### updates the udev rules for the USB sound card ####
    if [[ "$card" = true ]] 
    then
    echo "Ok, c'est parti - Changement des règles udev pour la carte son USB"
               sudo cp /home/pi/svxlinkbuilder/addons/cm-108.rules /etc/udev/rules.d/
               sudo udevadm control --reload-rules
               sudo udevadm trigger
                
    else
    echo "ok, donc, je ne fais pas de changements"           
    fi               
fi
    echo -e "$(date)" "${GREEN}Mis à jour audio, carte-son factice incluse pour un Web Socle.${NORMAL}" | sudo tee -a /var/log/install.log
plughw_setting="0"
channel_setting="0"
}
function seeed_sound_card_detected {
HID=false
GPIOD=true
card=true
plughw_setting="seeed2micvoicecard,0"
channel_setting="1"
}
function  other_sound_card_detected {
HID=false
GPIOD=true
card=true
plughw_setting="0"
channel_setting="0"
}
function no_sound_card_detected{
HID=false
GPIOD=false
card=false				
plughw_setting="0"
channel_setting="0"
}
