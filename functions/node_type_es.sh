#!/bin/bash
node=""
function nodeoption {
    NODE_OPTION=$(whiptail --title "Svxlink" --menu "¿Elija el tipo de nodo que desea?" 14 78 5 \
            "1" " Nodo simplex sin SvxReflector" \
            "2" " Nodo simplex con SvxReflector" \
            "3" "Nodo repetidor sin SvxReflector" \
            "4" "Nodo repetidor con SvxReflector" 3>&1 1>&2 2>&3)

    if [[ "$NODE_OPTION" -eq "1" ]] 
    then
        echo -e "${CYAN}Elija Nodo Simplex sin SvxReflector ${WHITE}" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "2" ]] 
    then
        echo -e "${CYAN}Elija Nodo Simplex con SvxReflector ${WHITE}" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "3" ]] 
    then
        echo -e "${CYAN}Elija Nodo repetidor sin SvxReflector ${WHITE}" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "4" ]] 
    then
        echo -e "${CYAN}Elija Nodo repetidor con SvxReflector ${WHITE}" | sudo tee -a /var/log/install.log
    else 
        echo -E "${RED}Ninguna opción elegida ${WHITE}" | sudo tee -a /var/log/install.log
fi
echo "${GREEN}Node Option ${WHITE} $NODE_OPTION"
# Determine the logic module from NODE_OPTION
if [ "$NODE_OPTION" -eq "1" ] || [ "$NODE_OPTION" -eq "2" ]; then
    LOGIC_MODULE="SimplexLogic"
elif [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then
    LOGIC_MODULE="RepeaterLogic"
else
    echo "Invalid node option selected" >&2
    exit 1
fi
if [ "$LOGIC_MODULE" = "SimplexLogic" ]; then
    NOT_LOGIC_MODULE="RepeaterLogic"
else
    NOT_LOGIC_MODULE="SimplexLogic"
fi

export NOT_LOGIC_MODULE
echo "Hidden logic module: $NOT_LOGIC_MODULE"
sudo sed -i "/^\[$NOT_LOGIC_MODULE\]/,/^\[/{/^$/!d; /^\\[$NOT_LOGIC_MODULE\\]/d}" /etc/svxlink/svxlink.conf
export LOGIC_MODULE
echo "Using logic module: $LOGIC_MODULE"

export NODE_OPTION; 
}
            
