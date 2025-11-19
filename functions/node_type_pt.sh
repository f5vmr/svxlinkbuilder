#!/bin/bash
node=""
function nodeoption {
    NODE_OPTION=$(whiptail --title "Svxlink" --menu "Escolhe o tipo de node que queres usar" 14 78 5 \
            "1" " Simplex Node sem SvxReflector" \
            "2" " Simplex Node com SvxReflector" \
            "3" "Repeater Node sem SvxReflector" \
            "4" "Repeater Node com SvxReflector" 3>&1 1>&2 2>&3)

    if [ "$NODE_OPTION" -eq "1" ] 
    then
        echo -e "${CYAN}Escolheste Simplex Node sem SvxReflector ${WHITE}" | tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "2" ] 
    then
        echo -e "${CYAN}Escolheste Simplex Node com UK SvxReflector ${WHITE}" | tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "3" ] 
    then
        echo -e "${CYAN}Escolheste Repeater Node sem SvxReflector ${WHITE}" | tee -a /var/log/install.log
    elif [ "$NODE_OPTION" -eq "4" ] 
    then
        echo -e "${CYAN}Escolheste Repeater Node com UK SvxReflector ${WHITE}" | tee -a /var/log/install.log
    else 
        echo -e "${RED}Nenhuma opção escolhida${WHITE}" | tee -a /var/log/install.log
fi
    echo "${GREEN}Opção do node ${WHITE} $NODE_OPTION"
    # Determine the logic module from NODE_OPTION
    if [ "$NODE_OPTION" -eq "1" ] || [ "$NODE_OPTION" -eq "2" ]; then
        LOGIC_MODULE="SimplexLogic"
    elif [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then
        LOGIC_MODULE="RepeaterLogic"
    else
        echo "Opção de node invalida" >&2
        exit 1
    fi
    if [ "$LOGIC_MODULE" = "SimplexLogic" ]; then
        NOT_LOGIC_MODULE="RepeaterLogic"
    else
        NOT_LOGIC_MODULE="SimplexLogic"
    fi

export NOT_LOGIC_MODULE


echo "O Modo $NOT_LOGIC_MODULE vai ser removido do svxlink.conf" | tee -a /var/log/install.log
export LOGIC_MODULE
echo "A utilizar o node: $LOGIC_MODULE" | tee -a /var/log/install.log

export NODE_OPTION; 
}
