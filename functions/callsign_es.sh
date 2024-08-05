#!/bin/bash
function callsign {
get_CallVar() {
    call=$(whiptail --inputbox "Ingrese el indicativo del nodo:" 8 78 3>&1 1>&2 2>&3)
    echo -e "${CYAN}$call${WHITE}"
}

while true; do
    user_input=$(get_CallVar)
    
    ## Check if input is empty
    if [ -z "$user_input" ]
    then
        whiptail --msgbox "El indicativo del nodo no puede estar vacío. Inténtalo de nuevo." 8 78
    else
        ## If input is not empty, break the loop
        break
    fi
done
CALL=${user_input^^}
## Use the non-empty name

	echo -e "$(date)" "${GREEN} #### Creando nodo con indicativo " $CALL " #### ${NORMAL}" | sudo tee -a  /var/log/install.log    
}