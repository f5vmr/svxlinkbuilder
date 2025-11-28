#!/bin/bash
#### Metar Info ####
function modulemetar {
 
whiptail --title "Metar Info" --yesno "Queres configurar este modulo?" 8 78  3>&1 1>&2 2>&3
    if [ $? -eq "0" ] 
    then
        sleep 1
    selected=$(whiptail --title "Metar Info" --checklist "Escolhe os Aeroportos: Podes alterar tambem no Painel" 24 78 17 \
        "LPCO" "Coimbra" OFF \
        "LPCS" "Cascais" OFF \
        "LPFL" "Flores" OFF \
        "LPGR" "Graciosa" OFF \
        "LPHR" "Horta" OFF \
        "LPPE" "Évora" OFF \
        "LPPI" "Pico" OFF \
        "LPPS" "Porto Santo" OFF \
        "LPPT" "Portimã" OFF \
        "LPSJ" "São Jorge" OFF \
        "LPST" "Sintra" OFF \
        "LPVZ" "Gonçalves Lobato" OFF \
        "LPVR" "Vila Real" OFF \
        "LPMA" "Madeira" OFF \
        "LPPT" "Lisboa" OFF \
        "LPPR" "Porto" OFF \
        "LPFR" "Faro" OFF \
        "LPBG" "Braga" OFF \
        "LPBJ" "Beja" OFF \
        "LPBR" "Bragança" OFF \
        "LPFR" "Funchal" OFF 3>&1 1>&2 2>&3)
        selected=$(echo "$selected" | sed 's/"//g')
        selected=$(echo "$selected" | tr ' ' ',')
        sed -i "s/AIRPORTS=.*/AIRPORTS=$selected/g"  /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        sleep 5
    specific_airport=$(whiptail --title "Metar Info" --radiolist "Escolhe o codigo ICAO para o Aeroporto por defeito: " 24 78 17 \
        "LPCO" "Coimbra" OFF \
        "LPCS" "Cascais" OFF \
        "LPFL" "Flores" OFF \
        "LPGR" "Graciosa" OFF \
        "LPHR" "Horta" OFF \
        "LPPE" "Évora" OFF \
        "LPPI" "Pico" OFF \
        "LPPS" "Porto Santo" OFF \
        "LPPT" "Portimã" OFF \
        "LPSJ" "São Jorge" OFF \
        "LPST" "Sintra" OFF \
        "LPVZ" "Gonçalves Lobato" OFF \
        "LPVR" "Vila Real" OFF \
        "LPMA" "Madeira" OFF \
        "LPPT" "Lisboa" OFF \
        "LPPR" "Porto" OFF \
        "LPFR" "Faro" OFF \
        "LPBG" "Braga" OFF \
        "LPBJ" "Beja" OFF \
        "LPBR" "Bragança" OFF \
        "LPFR" "Funchal" OFF 3>&1 1>&2 2>&3)
        specific_airport=$(echo "$specific_airport" | sed 's/"//g')
        sed -i "s/\STARTDEFAULT=.*/STARTDEFAULT=$specific_airport/g" /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        echo -e "$(date)" "${GREEN} $selected Aeroportos incluidos no aeroporto por defeito $specific_airport ${NORMAL}" | sudo tee -a /var/log/install.log   
    else
     sed -i 's/,ModuleMetarInfo//' /etc/svxlink/svxlink.conf
    # removing MetarInfo from the MODULES= line in both Simplex and Duplex
    fi
}
