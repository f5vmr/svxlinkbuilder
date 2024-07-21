#!/bin/bash
node=""
function nodeoption {
    NODE_OPTION=$(whiptail --title "Svxlink" --menu "Please enter the type of node you want to use" 14 78 5 \
            "1" " Simplex Node without SvxReflector" \
            "2" " Simplex Node with SvxReflector" \
            "3" "Repeater Node without SvxReflector" \
            "4" "Repeater Node with SvxReflector" 3>&1 1>&2 2>&3)

    if [ "$NODE_OPTION" -eq "1" ] 
    then
        echo -e "${CYAN}You chose Simplex Node without SvxReflector${WHITE}" | sudo tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "2" ] 
    then
        echo -e "${CYAN}You chose Simplex Node with UK SvxReflector${WHITE}" | sudo tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "3" ] 
    then
        echo -e "${CYAN}You chose Repeater Node without SvxReflector${WHITE}" | sudo tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "4" ] 
    then
        echo -e "${CYAN}You chose Repeater Node with UK SvxReflector${WHITE}" | sudo tee -a /var/log/install.log
    else 
        echo -e "${RED}You did not choose anything${WHITE}" | sudo tee -a /var/log/install.log
fi
echo Node Option $NODE_OPTION
export NODE_OPTION; 

}
            
