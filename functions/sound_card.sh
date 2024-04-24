#!/bin/bash
function soundcard {

card=false

## Run lsusb and filter the output to check for a USB sound card
lsusb_output=$(lsusb)

## Check if the USB sound card is present in the lsusb output
if echo "$lsusb_output" | grep -q "C-Media"; 
then
    echo "USB sound card is present."
    USB_sound_card_present=true
else
    echo "USB sound card is not present."
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

    SOUND_OPTION=$(whiptail --title "USB Soundcard" --menu "Select from the options below." 12 78 4 \
        "1" "Fully Modified for Transmit and Receive" \
        "2" "Fully Modified for Transmit Only" \
        "3" "Unmodified (use the GPIOD to control Squelch and PTT )" 3>&1 1>&2 2>&3)      
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
    echo "Invalid option"
    fi
    echo "HID is set to $HID"
    echo "GPIOD is set to $GPIOD"
    if [[ "$HID" = true ]] 
    then 
#### updates the udev rules for the USB sound card #####
    if [[ "$card" = true ]] 
    then
    echo "Ok, Let's add the updated rules"
               sudo cp /home/pi/svxlinkbuilder/addons/cm-108.rules /etc/udev/rules.d/
               sudo udevadm control --reload-rules
               sudo udevadm trigger
                
    else
    echo "ok, then I will make no other changes"           
    fi 
fi
    echo -e "$(date)" "${GREEN}Audio Updates including Dummy Sound Card for Darkice complete${NORMAL}" | tee -a /var/log/install.log
				
}