#!/bin/bash
function callsign {
get_CallVar() {
    call=$(whiptail --inputbox "Insere o callsign do node:" 8 78 3>&1 1>&2 2>&3)
    echo -e "${CYAN}$call${WHITE}" | sudo tee -a  /var/log/install.log 
}

while true; do
    user_input=$(get_CallVar)
    
    ## Check if input is empty
    if [ -z "$user_input" ]
    then
        whiptail --msgbox "O callsign do node não pode estar em branco. Por favor tenta novamente." 8 78
    else
        ## If input is not empty, break the loop
        break
    fi
done
CALL=${user_input^^}
## Use the non-empty name

	echo -e "$(date)" "${GREEN} #### A criar o node com o Callsign " $CALL " #### ${NORMAL}" | sudo tee -a  /var/log/install.log    
}
