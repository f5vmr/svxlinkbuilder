#!/bin/bash
node=""
function nodeoption {
    NODE_OPTION=$(whiptail --title "Svxlink" --menu "SVP choisir le type de noed vous desirez?" 12 78 5 \
            "1" " Noed Simplex  sans SvxReflecteur" \
            "2" " Noed Simplex  avec SvxReflecteur" \
            "3" "Noed Repététrice sans SvxReflecteur" \
            "4" "Noed Repététrice avec SvxReflecteur" 3>&1 1>&2 2>&3)

    if [[ "$NODE_OPTION" -eq "1" ]] 
    then
        echo -e "${CYAN}Choisi Noed Simplex sans SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log > /dev/null    
    elif [[ "$NODE_OPTION" -eq "2" ]] 
    then
        echo -e "${CYAN}Choisi Noed Simplex avec SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log > /dev/null    
    elif [[ "$NODE_OPTION" -eq "3" ]] 
    then
        echo -e "${CYAN}Choisi Noed Répéteur sans SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log > /dev/null    
    elif [[ "$NODE_OPTION" -eq "4" ]] 
    then
        echo -e "${CYAN}Choisi Noed Répéteur avec SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log > /dev/null    
    else 
        echo -e "${RED}Aucune option choisie ${WHITE}" | sudo tee -a /var/log/install.log > /dev/null
    fi
echo -e "${GREEN}Node Option ${WHITE}" $NODE_OPTION
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
echo "Unused logic module: $NOT_LOGIC_MODULE"
sudo sed -i '/^\['"$NOT_LOGIC_MODULE"'\]/,/^\[/ { /^\['"$NOT_LOGIC_MODULE"'\]/d; /^\[/!d }' /etc/svxlink/svxlink.conf
echo "The logic module $NOT_LOGIC_MODULE has been removed from svxlink.conf" | sudo tee -a /var/log/install.log > /dev/null
export LOGIC_MODULE
echo "Using logic module: $LOGIC_MODULE" | sudo tee -a /var/log/install.log > /dev/null
export NODE_OPTION; 
}
            
