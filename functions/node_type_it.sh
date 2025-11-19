#!/bin/bash
node=""
function nodeoption {
    NODE_OPTION=$(whiptail --title "Svxlink" --menu "Inserisci il tipo di nodo che vuoi utilizzare" 14 78 5 \
            "1" " Nodo simplex senza SvxReflector" \
            "2" " Nodo simplex con SvxReflector" \
            "3" " Nodo ripetitore senza SvxReflector" \
            "4" " Nodo ripetitore con SvxReflector" 3>&1 1>&2 2>&3)

    if [ "$NODE_OPTION" -eq "1" ] 
    then
        echo -e "${CYAN}Hai scelto un nodo simplex senza SvxReflector ${WHITE}" | tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "2" ] 
    then
        echo -e "${CYAN}Hai scelto un nodo simplex con SvxReflector ${WHITE}" | tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "3" ] 
    then
        echo -e "${CYAN}Hai scelto un nodo ripetitore senza SvxReflector ${WHITE}" | tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "4" ] 
    then
        echo -e "${CYAN}Hai scelto un nodo ripetitore con SvxReflector ${WHITE}" | tee -a /var/log/install.log
    else 
        echo -e "${RED}Non è stata effettuata alcuna selezione${WHITE}" | tee -a /var/log/install.log
fi
    echo "${GREEN}Opzione del nodo ${WHITE} $NODE_OPTION"
    # Determine the logic module from NODE_OPTION
    if [ "$NODE_OPTION" -eq "1" ] || [ "$NODE_OPTION" -eq "2" ]; then
        LOGIC_MODULE="SimplexLogic"
    elif [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then
        LOGIC_MODULE="RepeaterLogic"
    else
        echo "L'opzione del nodo selezionata non è valida" >&2
        exit 1
    fi
    if [ "$LOGIC_MODULE" = "SimplexLogic" ]; then
        NOT_LOGIC_MODULE="RepeaterLogic"
    else
        NOT_LOGIC_MODULE="SimplexLogic"
    fi

export NOT_LOGIC_MODULE


echo "Il modulo logico $NOT_LOGIC_MODULE sarà rimosso da svxlink.conf" | tee -a /var/log/install.log
export LOGIC_MODULE
echo "Utilizzo del modulo logico: $LOGIC_MODULE" | tee -a /var/log/install.log

export NODE_OPTION; 
}

