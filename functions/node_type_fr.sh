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
        echo -e "${CYAN}Choisi Noed Simplex sans SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "2" ]] 
    then
        echo -e "${CYAN}Choisi Noed Simplex avec SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "3" ]] 
    then
        echo -e "${CYAN}Choisi Noed Répéteur sans SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log
    elif [[ "$NODE_OPTION" -eq "4" ]] 
    then
        echo -e "${CYAN}Choisi Noed Répéteur avec SvxReflecteur ${WHITE}" | sudo tee -a /var/log/install.log
    else 
        echo -e "${RED}Aucune option choisie ${WHITE}" | sudo tee -a /var/log/install.log
fi
echo -e "${GREEN}Node Option ${WHITE}" $NODE_OPTION
export NODE_OPTION; 
}
            
