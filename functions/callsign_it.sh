#!/bin/bash
function callsign {
get_CallVar() {
    call=$(whiptail --inputbox "Inserisci il nominativo del nodo:" 8 78 3>&1 1>&2 2>&3)
    echo -e "${CYAN}$call${WHITE}" >> /var/log/install.log > /dev/null 
}

while true; do
    user_input=$(get_CallVar)
    
    ## Check if input is empty
    if [ -z "$user_input" ]
    then
        whiptail --msgbox "Il nominativo del nodo non può essere vuoto. Prova di nuovo." 8 78
    else
        ## If input is not empty, break the loop
        break
    fi
done
CALL=${user_input^^}
## Use the non-empty name

	echo -e "$(date)" "${GREEN} #### Creazione di un nodo con il nominativo " $CALL " #### ${NORMAL}" >> /var/log/install.log > /dev/null
}
