#!/bin/bash
function callsign {
get_CallVar() {
    call=$(whiptail --inputbox "Entrez l'indicatif du node:" 8 78 3>&1 1>&2 2>&3)
    echo "$call"
}


while true; do
    user_input=$(get_CallVar)
    
    ## Check if input is empty
    if [ -z "$user_input" ] 
    then
        whiptail --msgbox "L'indicatif du Node ne doit pas etre vide. Essayé encore une fois." 8 78
    else
        ## If input is not empty, break the loop
        break
    fi
done
CALL=${user_input^^}
## Use the non-empty name

	echo -e "$(date)" "${GREEN} #### Creation du Node " $CALL " #### ${NORMAL}" | tee -a  /var/log/install.log  
}