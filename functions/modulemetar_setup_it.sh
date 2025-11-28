#!/bin/bash
#### Metar Info ####
function modulemetar {
 
whiptail --title "Informazioni METAR" --yesno "Vuoi configurare questo modulo?" 8 78  3>&1 1>&2 2>&3
    if [ $? -eq "0" ] 
    then
        sleep 1
    selected=$(whiptail --title "Informazioni METAR" --checklist "Seleziona gli aeroporti: puoi cambiarli nella dashboard" 24 78 17 \
        "LIMC" "Milano Malpensa" OFF \
        "LIML" "Milano Linate" OFF \
        "LIME" "Bergamo Orio al Serio" OFF \
        "LIRF" "Roma Fiumicino" OFF \
        "LIRN" "Napoli Capodichino" OFF \
        "LIPZ" "Venezia Marco Polo" OFF \
        "LIRQ" "Firenze Peretola" OFF \
        "LICJ" "Catania Fontanarossa" OFF \
        "LIBD" "Bologna G. Marconi" OFF \
        "LIPA" "Palermo Facolne e Borsellino" OFF \
        "LICC" "Cagliari Elmas" OFF \
        "LILM" "Lamezia Terme" OFF \
        "LIPR" "Rimini Federico Fellini" OFF \
        "LIPX" "Verona Villafranca" OFF \
        "LIDB" "Brindisi Papola Casale" OFF \
        "LIEE" "Genova Cristoforo Colombo" OFF \
        "LIPQ" "Ancona Falconara" OFF \
        "LIPY" "Treviso Canova" OFF \
        "LIDT" "Trapani Birgi" OFF \
        "LIPK" "Trieste Friuli Venezia Giulia" OFF 3>&1 1>&2 2>&3)
        selected=$(echo "$selected" | sed 's/"//g')
        selected=$(echo "$selected" | tr ' ' ',')
        sed -i "s/AIRPORTS=.*/AIRPORTS=$selected/g"  /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        sleep 5
    specific_airport=$(whiptail --title "Informazioni METAR" --radiolist "Specifica un codice ICAO per un aeroporto predefinito: " 24 78 17 \
        "LIMC" "Milano Malpensa" OFF \
        "LIML" "Milano Linate" OFF \
        "LIME" "Bergamo Orio al Serio" OFF \
        "LIRF" "Roma Fiumicino" OFF \
        "LIRN" "Napoli Capodichino" OFF \
        "LIPZ" "Venezia Marco Polo" OFF \
        "LIRQ" "Firenze Peretola" OFF \
        "LICJ" "Catania Fontanarossa" OFF \
        "LIBD" "Bologna G. Marconi" OFF \
        "LIPA" "Palermo Facolne e Borsellino" OFF \
        "LICC" "Cagliari Elmas" OFF \
        "LILM" "Lamezia Terme" OFF \
        "LIPR" "Rimini Federico Fellini" OFF \
        "LIPX" "Verona Villafranca" OFF \
        "LIDB" "Brindisi Papola Casale" OFF \
        "LIEE" "Genova Cristoforo Colombo" OFF \
        "LIPQ" "Ancona Falconara" OFF \
        "LIPY" "Treviso Canova" OFF \
        "LIDT" "Trapani Birgi" OFF \
        "LIPK" "Trieste Friuli Venezia Giulia" OFF 3>&1 1>&2 2>&3)
        specific_airport=$(echo "$specific_airport" | sed 's/"//g')
        sed -i "s/\STARTDEFAULT=.*/STARTDEFAULT=$specific_airport/g" /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        echo -e "$(date)" "${GREEN} $selected aeroporti inclusi con l'aeroporto predefinito $specific_airport ${NORMAL}" | sudo tee -a /var/log/install.log > dev/null   
    else
     sed -i 's/,ModuleMetarInfo//' /etc/svxlink/svxlink.conf
    # removing MetarInfo from the MODULES= line in both Simplex and Duplex
    fi
}
