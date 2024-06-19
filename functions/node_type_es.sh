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
        echo "Elija Nodo Simplex sin SvxReflector" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "2" ]] 
    then
        echo "Elija Nodo Simplex con SvxReflector" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "3" ]] 
    then
        echo "Elija Nodo repetidor sin SvxReflector" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "4" ]] 
    then
        echo "Elija Nodo repetidor con SvxReflector" | sudo tee -a /var/log/install.log
    else 
        echo "Ninguna opción elegida" | sudo tee -a /var/log/install.log
fi
echo Node Option $NODE_OPTION

}
            
