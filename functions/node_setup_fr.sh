#!/bin/bash
#### Recall options
function nodeset {
    if [[ $NODE_OPTION  == "1" ]] 
    then 
    node="Simplex sans Svxreflector"
     sed -i 's/LOGICS=SimplexLogic,ReflectorLogic/LOGICS=SimplexLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LINKS=/\#LINKS=/g' /etc/svxlink/svxlink.conf
    elif [[ $NODE_OPTION  == "2" ]] 
    then
    node="Simplex avec UK Svxreflector"
    auth_key=$(whiptail --passwordbox "Selectionner un mot-pass SvxReflector" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
     sed -i "s/AUTH_KEY=\"GET YOUR OWN KEY\"/AUTH_KEY=\"$auth_key\"/g" /etc/svxlink/svxlink.conf 
    elif [[ $NODE_OPTION  == "3" ]] 
    then
    node="Repeater sans Svxreflector"
     sed -i 's/set for SimplexLogic/set pour RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LOGICS=SimplexLogic,ReflectorLogic/LOGICS=RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LINKS=/\#LINKS=/g' /etc/svxlink/svxlink.conf
    elif [[ $NODE_OPTION  == "4" ]] 
    then
    node="Repeater avec UK Svxreflector"
    auth_key=$(whiptail --passwordbox "Selectionner un mot-pass SvxReflector" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
    
     sed -i 's/set for SimplexLogic/set pour RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LOGICS=SimplexLogic/LOGICS=RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i "s/AUTH_KEY=\"GET YOUR OWN KEY\"/AUTH_KEY=\"$auth_key\"/g" /etc/svxlink/svxlink.conf 
    else    
    node="unset"
    fi
whiptail --title "Node" --msgbox "Selectioné node-type $node" 8 78
## Time to change the node

##That's the Logics taken care of now we need to change the sound card settings 
output=$(aplay -l)

## Use grep to find the line containing the desired sound card
line=$(echo "$output" | grep "USB Audio")

## Extract the card number from the line
card_number=$(echo "$line" | awk '{print $2}' | tr -d ':')
whiptail --title "Sound Card" --msgbox "La carte-son USB se trouve à carte $card_number." 8 78

## Use sed to replace the line with the new one even if there is no change

 sed -i "s/AUDIO_DEV=alsa:plughw:0/AUDIO_DEV=alsa:plughw:$card_number/g" /etc/svxlink/svxlink.conf
## so even if it is '0' it is still '0'
## now we need to change the settings for COS and Squelch.
## We need to check if the Squelch is set to '1' or '0'
    ## if it is '1' then we need to change it to '0'
    ## if it is '0' then we need to change it to '1'
## we need to do this for both the Simplex and Repeater
## We need to check if the COS is set to '0' or '1'
    ## if it is '0' then we need to change it to '1'
    ## if it is '1' then we need to change it to '0'
    ## WE have three options
        ## 1. GPIOD on Transmit and Receive determined by $HID=false $GPIOD=true $card=false
        ## 2. HID on Transmit and GPIOD on Receive determined by $HID=true $GPIOD=true $card=true
        ## 3. HID on Transmit and Receive determined by $HID=true $GPIOD=false $card=true

if [[ "$HID" == "false" ]] && [[ "$GPIOD" == "true" ]] && [[ "$card" == "false" ]]; then

        ptt_direction=$(whiptail --title "PTT" --radiolist "Selectionner PTT direction" 8 78 3 \
        "High" "Transmit PTT is active-High" OFF \
        "Low" "Transmit PTT is active-Low" OFF 3>&1 1>&2 2>&3)
        
        ptt_pin=$(whiptail --title "PTT Pin" --radiolist "Selectionner broche PTT (gpio #)" 8 78 3\
            "gpio 24" "as PTT Pin" ON \
            "gpio 18" "as PTT Pin" OFF \
            "gpio 7" "as PTT Pin" OFF 3>&1 1>&2 2>&3)
        
        ptt_pin="${ptt_pin#"gpio "}"

            if [[ "$ptt_direction" == "High" ]]; then            
                 sed -i 's/\#PTT_TYPE=Hidraw/PTT_TYPE=GPIOD/g' /etc/svxlink/svxlink.conf
                 sed -i 's/\#PTT_GPIOD_CHIP/PTT_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
                 sed -i "s/\#PTT_GPIOD_LINE=!24/PTT_GPIOD_LINE=$ptt_pin/g" /etc/svxlink/svxlink.conf
            
            elif [[ "$ptt_direction" == "Low" ]]; then
                sed -i 's/\#PTT_TYPE=Hidraw/PTT_TYPE=GPIOD/g' /etc/svxlink/svxlink.conf
                sed -i 's/\#PTT_GPIOD_CHIP/PTT_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
                sed -i "s/\#PTT_GPIOD_LINE=!24/PTT_GPIOD_LINE=!$ptt_pin/g" /etc/svxlink/svxlink.conf                
            else 
                echo no action here
            fi

        cos_direction=$(whiptail --title "COS" --radiolist "Selectionner COS direction" 8 78 2 \
        "High" "Receive COS is active-High" OFF \
        "Low" "Receive COS is active-Low" OFF 3>&1 1>&2 2>&3)
        cos_pin=$(whiptail --title "COS Pin" --radiolist "Selectionner broche COS  (gpio #)" 8 78 3 \
            "gpio 23" "as COS Pin" ON \
            "gpio 17" "as COS Pin" OFF \
            "gpio 8" "as COS Pin" OFF 3>&1 1>&2 2>&3)
        
        cos_pin="${cos_pin#"gpio "}"
                sed -i 's/\#SQL_DET=GPIOD/SQL_DET=GPIOD/g' /etc/svxlink/svxlink.conf
            if [[ "$cos_direction" == "High" ]]; then
                 sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
                 sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=$cos_pin/g" /etc/svxlink/svxlink.conf
            
            elif [[ "$cos_direction" == "Low" ]]; then
                sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
                sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=!$cos_pin/g" /etc/svxlink/svxlink.conf
            else 
            echo no action here
            fi

##need to change the PTT and COS to GPIOD and all the statements to reflect this Unmodified SOundCard Unit - ask for GPIOD pins
elif [[ "$HID" == "true" ]] && [[ "$GPIOD" == "true" ]] && [[ "$card" == "true" ]]; then
                sed -i 's/\#PTT_TYPE=Hidraw/PTT_TYPE=Hidraw/g' /etc/svxlink/svxlink.conf
                sed -i 's/\#HID_DEVICE=/HID_DEVICE=/g' /etc/svxlink/svxlink.conf
                sed -i 's/\#HID_PTT_PIN=GPIO3/HID_PTT_PIN=GPIO3/g' /etc/svxlink/svxlink.conf


        cos_direction=$(whiptail --title "COS" --radiolist "Selectionner COS direction" 10 78 3 \
        "High" "Receive COS is active-High" OFF \
        "Low" "Receive COS is active-Low" OFF 3>&1 1>&2 2>&3)
        cos_pin=$(whiptail --title "COS Pin" --radiolist "Selectionner broche COS (gpio #)" 8 78 3\
            "gpio 23" "as COS Pin" ON \
            "gpio 17" "as COS Pin" OFF \
            "gpio 8" "as COS Pin" OFF 3>&1 1>&2 2>&3)
        
        cos_pin="${cos_pin#"gpio "}"
        ##need to change the PTT to HID and COS to GPIOD and all the statements to reflect this modified SoundCard Unit - ask for GPIOD pins
                sed -i 's/\#SQL_DET=GPIOD/SQL_DET=GPIOD/g' /etc/svxlink/svxlink.conf
            if [[ "$cos_direction" == "High" ]]; then
                sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
                sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=$cos_pin/g" /etc/svxlink/svxlink.conf
        
            elif [[ "$cos_direction" == "Low" ]]; then
                sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
                sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=!$cos_pin/g" /etc/svxlink/svxlink.conf
            else
            echo no action here
            fi
    elif [[ "$HID" == "true" ]] && [[ "$GPIOD" == "false" ]] && [[ "$card" == "true" ]]; then
            sed -i 's/\#PTT_TYPE=Hidraw/PTT_TYPE=Hidraw/g' /etc/svxlink/svxlink.conf
            sed -i 's/\#HID_DEVICE=/HID_DEVICE=/g' /etc/svxlink/svxlink.conf
            sed -i 's/\#HID_PTT_PIN=GPIO3/HID_PTT_PIN=GPIO3/g' /etc/svxlink/svxlink.conf
            sed -i 's/\#SQL_DET=GPIOD/SQL_DET=HIDRAW/g' /etc/svxlink/svxlink.conf
            sed -i 's/\#HID_SQL_DET/HID_SQL_DET/g' /etc/svxlink/svxlink.conf
                if [[ "$cos_direction" == "High" ]]; then
                sed -i's/=VOL_DN/=VOL_UP/g' /etc/svxlink/svxlink.conf       
                elif [[ "$cos_direction" == "Low" ]]; then
                echo leave everything as it is
                else
                echo no §action here
                fi
            else
    echo no action here
    fi
    sed -i "s/DEFAULT_LANG=en_GB/DEFAULT_LANG=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')/g" /etc/svxlink/svxlink.conf

##need to change the PTT and COS to HID and all the statements to reflect this modified SoundCard Unit - ask for GPIOD pins




}

