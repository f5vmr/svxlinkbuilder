#!/bin/bash
function callsign {
get_CallVar() {
    call=$(whiptail --inputbox "Taper l'indicatif du point d'accès (noeud):" 8 78 3>&1 1>&2 2>&3)
    echo -e "${CYAN}$call${WHITE}"
}

while true; do
    user_input=$(get_CallVar)
    
    ## Check if input is empty
    if [ -z "$user_input" ] 
    then
        whiptail --msgbox "L'indicatif ne doit pas être vide. Essayez encore une fois." 8 78
    else
        ## If input is not empty, break the loop
        break
    fi
done
CALL=${user_input^^}
## Use the non-empty name

	echo -e "$(date)" "${GREEN} #### Creation du point d'accès (Noeud) " $CALL " #### ${NORMAL}" >> /var/log/install.log > /dev/null  
}
