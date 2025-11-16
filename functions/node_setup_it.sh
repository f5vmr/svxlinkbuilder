#!/bin/bash
#### Recall Node_Options
function nodeset {
    if [[ $NODE_OPTION  == "1" ]] 
    then 
    node="Simplex senza Svxreflector"
     sed -i 's/LOGICS=SimplexLogic,ReflectorLogic/LOGICS=SimplexLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LINKS=/\#LINKS=/g' /etc/svxlink/svxlink.conf
    elif [[ $NODE_OPTION  == "2" ]] 
    then
    node="Simplex con UK Svxreflector"
    auth_key=$(whiptail --passwordbox "Inserisci la password del tuo SvxReflector" 8 78 --title "Inserimento password" 3>&1 1>&2 2>&3)
     sed -i "s/AUTH_KEY=\"Change this key now\"/AUTH_KEY=\"$auth_key\"/g" /etc/svxlink/svxlink.conf 
    elif [[ $NODE_OPTION  == "3" ]] 
    then
    node="Repeater senza Svxreflector"
     sed -i 's/set for SimplexLogic/set for RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LOGICS=SimplexLogic,ReflectorLogic/LOGICS=RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LINKS=/\#LINKS=/g' /etc/svxlink/svxlink.conf
    elif [[ $NODE_OPTION  == "4" ]] 
    then
    node="Repeater con UK Svxreflector"
    auth_key=$(whiptail --passwordbox "Inserisci la password del tuo SvxReflector" 8 78 --title "Inserimento password" 3>&1 1>&2 2>&3)
    
     sed -i 's/set for SimplexLogic/set for RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i 's/LOGICS=SimplexLogic/LOGICS=RepeaterLogic/g' /etc/svxlink/svxlink.conf
     sed -i "s/AUTH_KEY=\"Change this key now\"/AUTH_KEY=\"$auth_key\"/g" /etc/svxlink/svxlink.conf
     sed -i 's/CONNECT_LOGICS=SimplexLogic:9:/CONNECT_LOGICS=RepeaterLogic:9:/g' /etc/svxlink/svxlink.conf
    else    
    node="unset"
    fi  
whiptail --title "Nodo" --msgbox "Hai selezionato il tipo di nodo $node" 8 78
## Time to change the node
node_type=$(echo $node | awk '{print $1}')
sed -i "s/SvxLink server setting: SimplexLogic/SvxLink server setting: $node_type/" /etc/svxlink/svxlink.conf
##That's the Logics taken care of now we need to change the sound card settings 
## Use sed to replace the line with the new one even if there is no change

 sed -i "s/AUDIO_DEV=alsa:plughw:0/AUDIO_DEV=alsa:plughw:$plughw_setting/g" /etc/svxlink/svxlink.conf
 sed -i "s/AUDIO_CHANNEL=0/AUDIO_CHANNEL=$channel_setting/g" /etc/svxlink/svxlink.conf
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

    ptt_direction=$(whiptail --title "PTT" --radiolist "Seleziona la direzione PTT" 8 78 3 \
    "Alto" "La trasmissione PTT è attiva a livello alto" OFF \
    "Basso" "La trasmissione PTT è attiva a livello basso" OFF 3>&1 1>&2 2>&3)

    ptt_pin=$(whiptail --title "Pin del PTT" --radiolist "Inserisci il pin del PTT (gpio #)" 16 78 8 \
        "gpio 24" "come pin PTT" ON \
        "gpio 18" "come pin PTT" OFF \
        "gpio 7" "Pin PTT per Spotnik" OFF \
        "gpio 17" "PTT per USVxCard" OFF \
        "gpio 16" "PTT per rf-guru" OFF \
        "gpio 12" "PTT modalità speciale" OFF \
        "Personalizza" "Specifica la tua porta GPIO" OFF 3>&1 1>&2 2>&3)

    if [[ "$ptt_pin" == "Personalizza" ]]; then
        ptt_pin=$(whiptail --inputbox "Specifica la tua porta GPIO per il PTT" 8 78 3>&1 1>&2 2>&3)
    else
        ptt_pin="${ptt_pin#"gpio "}"
    fi

    if [[ "$ptt_direction" == "Alto" ]]; then
         sed -i 's/\#PTT_TYPE=GPIOD/PTT_TYPE=GPIOD/g' /etc/svxlink/svxlink.conf
         sed -i 's/\#PTT_GPIOD_CHIP/PTT_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
         sed -i "s/\#PTT_GPIOD_LINE=24/PTT_GPIOD_LINE=!$ptt_pin/g" /etc/svxlink/svxlink.conf

    elif [[ "$ptt_direction" == "Basso" ]]; then
        sed -i 's/\#PTT_TYPE=GPIOD/PTT_TYPE=GPIOD/g' /etc/svxlink/svxlink.conf
        sed -i 's/\#PTT_GPIOD_CHIP/PTT_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
        sed -i "s/\#PTT_GPIOD_LINE=24/PTT_GPIOD_LINE=$ptt_pin/g" /etc/svxlink/svxlink.conf
    else
        echo no actions here.
    fi

    cos_direction=$(whiptail --title "COS" --radiolist "Seleziona la direzione COS" 8 78 2 \
    "Alto" "La ricezione COS è attiva a livello alto" OFF \
    "Basso" "La ricezione COS è attiva a livello basso" OFF 3>&1 1>&2 2>&3)

    cos_pin=$(whiptail --title "Pin COS" --radiolist "Inserisci il pin COS (gpio #)" 16 78 6 \
        "gpio 23" "come pin COS" ON \
        "gpio 17" "come pin COS" OFF \
        "gpio 8" "come pin COS" OFF \
        "gpio 10" "pin COS per Spotnik" OFF \
        "gpio 12" "COS per RF-Guru" OFF \
        "Personalizza" "Specifica la tua porta GPIO" OFF 3>&1 1>&2 2>&3)

    if [[ "$cos_pin" == "Personalizza" ]]; then
        cos_pin=$(whiptail --inputbox "Specifica la tua porta GPIO per il COS" 8 78 3>&1 1>&2 2>&3)
    else
        cos_pin="${cos_pin#"gpio "}"
    fi

    sed -i 's/\#SQL_DET=GPIOD/SQL_DET=GPIOD/g' /etc/svxlink/svxlink.conf
    if [[ "$cos_direction" == "Alto" ]]; then
        sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
        sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=!$cos_pin/g" /etc/svxlink/svxlink.conf

    elif [[ "$cos_direction" == "Basso" ]]; then
        sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
        sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=$cos_pin/g" /etc/svxlink/svxlink.conf
    else
        echo no action here
    fi

elif [[ "$HID" == "true" ]] && [[ "$GPIOD" == "true" ]] && [[ "$card" == "true" ]]; then
    sed -i 's/\#PTT_TYPE=GPIOD/PTT_TYPE=Hidraw/g' /etc/svxlink/svxlink.conf
    sed -i '/^\[Tx1\]$/,/^\[/{ /#HID_DEVICE/ s/#HID_DEVICE/HID_DEVICE/ }' /etc/svxlink/svxlink.conf
    sed -i 's/\#HID_PTT_PIN=GPIO3/HID_PTT_PIN=GPIO3/g' /etc/svxlink/svxlink.conf

    cos_direction=$(whiptail --title "COS" --radiolist "Seleziona la direzione COS" 10 78 3 \
    "Alto" "La ricezione COS è attiva a livello alto" OFF \
    "Basso" "La ricezione COS è attiva a livello basso" OFF 3>&1 1>&2 2>&3)

    cos_pin=$(whiptail --title "Pin COS" --radiolist "Inserisci il pin COS (gpio #)" 16 78 8 \
        "gpio 23" "come pin COS" ON \
        "gpio 17" "come pin COS" OFF \
        "gpio 8" "come pin COS" OFF \
        "gpio 10" "pin COS per Spotnik" OFF \
        "gpio 12" "COS per RF-Guru" OFF \
        "Personalizza" "Specifica la tua porta GPIO" OFF 3>&1 1>&2 2>&3)

    if [[ "$cos_pin" == "Personalizza" ]]; then
        cos_pin=$(whiptail --inputbox "Specifica la tua porta GPIO per il COS" 8 78 3>&1 1>&2 2>&3)
    else
        cos_pin="${cos_pin#"gpio "}"
    fi

    sed -i 's/\#SQL_DET=GPIOD/SQL_DET=GPIOD/g' /etc/svxlink/svxlink.conf
    if [[ "$cos_direction" == "Alto" ]]; then
        sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
        sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=!$cos_pin/g" /etc/svxlink/svxlink.conf

    elif [[ "$cos_direction" == "Basso" ]]; then
        sed -i 's/\#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
        sed -i "s/\#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=$cos_pin/g" /etc/svxlink/svxlink.conf
    else
        echo no action here
    fi

elif [[ "$HID" == "true" ]] && [[ "$GPIOD" == "false" ]] && [[ "$card" == "true" ]]; then
    sed -i 's/\#PTT_TYPE=GPIOD/PTT_TYPE=Hidraw/g' /etc/svxlink/svxlink.conf
    sed -i 's/\#HID_DEVICE=/HID_DEVICE=/g' /etc/svxlink/svxlink.conf
    sed -i 's/\#HID_PTT_PIN=GPIO3/HID_PTT_PIN=GPIO3/g' /etc/svxlink/svxlink.conf
    sed -i 's/\#SQL_DET=GPIOD/SQL_DET=HIDRAW/g' /etc/svxlink/svxlink.conf
    sed -i 's/\#HID_SQL_PIN/HID_SQL_PIN/g' /etc/svxlink/svxlink.conf
    if [[ "$cos_direction" == "Alto" ]]; then
        sed -i 's/=VOL_DN/=!VOL_DN/g' /etc/svxlink/svxlink.conf
    elif [[ "$cos_direction" == "Basso" ]]; then
        echo leave everything as it is
    else
        echo no action here   
    fi
else
    echo no action here    
fi
#### Need to check the Language in SVXLINK.CONF
#### The downloaded Model is en_GB, if not then change to en_US
if [[ $lang  == "en_US" ]]
then 
sed -i 's/en_GB/en_US/g' /etc/svxlink/svxlink.conf
else
echo ## no changes needed
fi
}

