#!/bin/bash
#### Metar Info ####
function modulemetar {
 
whiptail --title "Metar Info" --yesno "Do you wish to configure this module?" 8 78  3>&1 1>&2 2>&3
    if [ $? -eq "0" ] 
    then
        sleep 1
    selected=$(whiptail --title "Metar Info" --checklist "Choose which Airports: You can change them in the Dashboard" 24 78 17 \
        "EGLL" "London Heathrow" OFF \
        "EGKK" "London Gatwick" OFF \
        "EGCC" "Manchester" OFF \
        "EGBB" "Birmingham" OFF \
        "EGSS" "London Stansted" OFF \
        "EGPF" "Glasgow" OFF \
        "EGPH" "Edinburgh" OFF \
        "EGPD" "Aberdeen Dyce" OFF \
        "EGPK" "Prestwick" OFF \
        "EGHH" "Bournemouth" OFF \
        "EGHI" "Southampton" OFF \
        "EGNT" "Newcastle" OFF \
        "EGNX" "East Midlands" OFF \
        "EGGW" "London Luton" OFF \
        "EGGD" "Bristol" OFF \
        "EGCN" "Sheffield" OFF \
        "EGNM" "Leeds Bradford" OFF \
        "EGNS" "Ronaldsway" OFF \
        "EGAA" "Belfast Aldergrove" OFF \
        "EGBD" "Belfast City" OFF 3>&1 1>&2 2>&3)
        selected=$(echo "$selected" | sed 's/"//g')
        selected=$(echo "$selected" | tr ' ' ',')
        sed -i "s/AIRPORTS=.*/AIRPORTS=$selected/g"  /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        
    specific_airport=$(whiptail --title "Metar Info" --radiolist "Please specify an ICAO code for a default airport: " 24 78 17 \
        "EGLL" "London Heathrow" OFF \
        "EGKK" "London Gatwick" OFF \
        "EGCC" "Manchester" OFF \
        "EGBB" "Birmingham" OFF \
        "EGSS" "London Stansted" OFF \
        "EGPF" "Glasgow" OFF \
        "EGPH" "Edinburgh" OFF \
        "EGPD" "Aberdeen Dyce" OFF \
        "EGPK" "Prestwick" OFF \
        "EGHH" "Bournemouth" OFF \
        "EGHI" "Southampton" OFF \
        "EGNT" "Newcastle" OFF \
        "EGNX" "East Midlands" OFF \
        "EGGW" "London Luton" OFF \
        "EGGD" "Bristol" OFF \
        "EGCN" "Sheffield" OFF \
        "EGNM" "Leeds Bradford" OFF \
        "EGNS" "Ronaldsway" OFF \
        "EGAA" "Belfast Aldergrove" OFF \
        "EGBD" "Belfast City" OFF 3>&1 1>&2 2>&3)
        specific_airport=$(echo "$specific_airport" | sed 's/"//g')
        sed -i "s/\#STARTDEFAULT=EDDP/STARTDEFAULT=$specific_airport/g" /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        echo -e "$(date)" "${GREEN} $selected Airports included with default Airport $specific_airport ${NORMAL}" | sudo tee -a /var/log/install.log
   
    else
     sed -i 's/,ModuleMetarInfo//' /etc/svxlink/svxlink.conf
    # removing MetarInfo from the MODULES= line in both Simplex and Duplex
    fi
}