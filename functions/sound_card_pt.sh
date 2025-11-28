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
    echo "Placa de som USB detetada:" | sudo tee -a /var/log/install.log
    echo "$sound_cards" | grep -A 1 'USB-Audio'
    usb_sound_card_detected=true
fi

# Check for Seeed 2-mic voice card
if echo "$sound_cards" | grep -q 'seeed-2mic-voicecard'; then
    echo "Placa Seeed 2-mic voice detetada:" | sudo tee -a /var/log/install.log
    echo "$sound_cards" | grep -A 1 'seeed-2mic-voicecard'
    seeed_sound_card_detected=true
fi

# Check for any other sound cards not explicitly identified by name and not Loopback
if echo "$sound_cards" | grep -q '[0-9] \[' && ! echo "$sound_cards" | grep -q 'Loopback' && ! $usb_sound_card_detected && ! $seeed_sound_card_detected; then
    echo "Placa Generica detetada:" | sudo tee -a /var/log/install.log
    echo "$sound_cards" | grep -v 'Loopback' 
    other_sound_card_detected=true
fi

# If no sound card is detected or only Loopback card is detected
if ! $usb_sound_card_detected && ! $seeed_sound_card_detected && ! $other_sound_card_detected; then
    echo "Placa de som não detetada ou apenas a placa de Loopback detetada." | sudo tee -a /var/log/install.log
    no_sound_card_detected
fi

# Handle based on detected sound card type
if $usb_sound_card_detected; then
    echo "Defenindo detalhes da placa USB..." | sudo tee -a /var/log/install.log
    usb_sound_card_detected
    # Add your specific handling code here for USB sound card
fi

if $seeed_sound_card_detected; then
    echo "Defenindo detalhes da placa Seeed 2-mic ..." | sudo tee -a /var/log/install.log
    seeed_sound_card_detected  
    # Add your specific handling code here for Seeed 2-mic voice card
fi

if $other_sound_card_detected; then
    echo "Defenindo detalhes da placa Generica..." | sudo tee -a /var/log/install.log
    other_sound_card_detected
    # Add your specific handling code here for other sound cards
fi

}
## Print the assigned variable value

function usb_sound_card_detected {
echo "Variable assigned: $sound_card_variable"

    SOUND_OPTION=$(whiptail --title "Placa de som USB" --menu "Seleciona as seguintes opções." 12 78 4 \
        "1" "Modificado para TX e RX (UDEV only)" \
        "2" "Modificado so para TX (UDEV Tx & GPIOD Rx)" \
        "3" "Nao Modificado (usa o GPIOD para controlar o Squelch e o PTT )" 3>&1 1>&2 2>&3)      
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
    echo "Opção Invalida"
    fi
    echo "HID is set to $HID"
    echo "GPIOD is set to $GPIOD"
    if [[ "$HID" = true ]] 
    then 
#### updates the udev rules for the USB sound card ####
    if [[ "$card" = true ]] 
    then
    echo "Ok, Vamos actualizar as regras da placa USB"
               sudo cp /home/pi/svxlinkbuilder/addons/cm-108.rules /etc/udev/rules.d/
               sudo udevadm control --reload-rules
               sudo udevadm trigger
                
    else
    echo "ok, não foram feitas alterações"           
    fi 
fi
    echo -e "$(date)" "${GREEN}Audio Updates inclui placa de som Dummy para web socket.${NORMAL}" | tee -a /var/log/install.log > /dev/nullplughw_setting="0"
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
