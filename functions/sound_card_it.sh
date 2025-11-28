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
    echo "Scheda audio USB rilevata:" | sudo tee -a /var/log/install.log
    echo "$sound_cards" | grep -A 1 'USB-Audio'
    usb_sound_card_detected=true
fi

# Check for Seeed 2-mic voice card
if echo "$sound_cards" | grep -q 'seeed-2mic-voicecard'; then
    echo "Scheda vocale Seeed a 2 microfoni rilevata:" | sudo tee -a /var/log/install.log
    echo "$sound_cards" | grep -A 1 'seeed-2mic-voicecard'
    seeed_sound_card_detected=true
fi

# Check for any other sound cards not explicitly identified by name and not Loopback
if echo "$sound_cards" | grep -q '[0-9] \[' && ! echo "$sound_cards" | grep -q 'Loopback' && ! $usb_sound_card_detected && ! $seeed_sound_card_detected; then
    echo "Altra scheda audio rilevata:" | sudo tee -a /var/log/install.log
    echo "$sound_cards" | grep -v 'Loopback' 
    other_sound_card_detected=true
fi

# If no sound card is detected or only Loopback card is detected
if ! $usb_sound_card_detected && ! $seeed_sound_card_detected && ! $other_sound_card_detected; then
    echo "Nessuna scheda audio rilevata o rilevata solo la scheda Loopback." | sudo tee -a /var/log/install.log
    no_sound_card_detected
fi

# Handle based on detected sound card type
if $usb_sound_card_detected; then
    echo "Gestione delle specifiche della scheda audio USB..." | sudo tee -a /var/log/install.log
    usb_sound_card_detected
    # Add your specific handling code here for USB sound card
fi

if $seeed_sound_card_detected; then
    echo "Gestione delle specifiche della scheda vocale Seeed a 2 microfoni..." | sudo tee -a /var/log/install.log
    seeed_sound_card_detected  
    # Add your specific handling code here for Seeed 2-mic voice card
fi

if $other_sound_card_detected; then
    echo "Gestione delle specifiche di un'altra scheda audio..." | sudo tee -a /var/log/install.log
    other_sound_card_detected
    # Add your specific handling code here for other sound cards
fi

}
## Print the assigned variable value

function usb_sound_card_detected {
echo "Variabile assegnata: $sound_card_variable"

    SOUND_OPTION=$(whiptail --title "USB Soundcard" --menu "Select from the options below." 12 78 4 \
        "1" "Completamente modificata per trasmissione e ricezione (solo UDEV)" \
        "2" "Completamente modificata solo per trasmissione (UDEV Tx e GPIOD Rx)" \
        "3" "Non modificata (usa GPIOD per controllare sia lo squelch che il PTT )" 3>&1 1>&2 2>&3)
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
    echo "Opzione non valida"
    fi
    echo "HID è impostato su $HID"
    echo "GPIOD è impostato su $GPIOD"
    if [[ "$HID" = true ]] 
    then 
#### updates the udev rules for the USB sound card ####
    if [[ "$card" = true ]] 
    then
    echo "Ok, aggiungiamo le regole aggiornate"
               sudo cp /home/pi/svxlinkbuilder/addons/cm-108.rules /etc/udev/rules.d/
               sudo udevadm control --reload-rules
               sudo udevadm trigger
                
    else
    echo "Ok, allora non apporterò altre modifiche"
    fi 
fi
    echo -e "$(date)" "${GREEN}Aggiornamenti audio, inclusa la scheda audio fittizia per un web socket.${NORMAL}" | sudo tee -a /var/log/install.log
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
function no_sound_card_detected {
HID=false
GPIOD=false
card=false				
plughw_setting="0"
channel_setting="0"
}
