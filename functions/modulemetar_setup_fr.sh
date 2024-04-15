#!/bin/bash
##### Metar Info #####
function modulemetar {
 airports=("LFPG" "LFPO" "LFOB" "LFBL" "LFMN" "LFML" "LFBD" "LFRK" "LFRN" "LFRB" "LFRS" "LFBO" "LFMT" "LFLC" "LFLS" "LFLY" "LFLB" "LFST" "LFOT" "LFSL" "LFBE")
 
whiptail --title "Metar Info" --yesno "Do you wish to configure this module?" 8 78 3>&1 1>&2 2>&3
    if [ $? -eq "0" ] 
    then
selected=$(whiptail --title "Metar Info" --checklist "choose which Airports:" 27 78 20 \
        "LFPG" "Paris Charles de Gaulle" OFF \
        "LFPO" "Paris Orly" OFF \
        "LFOB" "Paris Beauvais" OFF \
        "LFBL" "Limoges Bellegarde" OFF \
        "LFMN" "Nice" OFF \
        "LFML" "Marseille" OFF \
        "LFBD" "Bordeaux" OFF \
        "LFRK" "Rouen" OFF \
        "LFRN" "Rennes" OFF \
        "LFRB" "Brest" OFF \
        "LFRS" "Nantes" OFF \
        "LFBO" "Toulouse" OFF \
        "LFMT" "Montpelier" OFF \
        "LFLC" "Clermont Ferrand" OFF \
        "LFLS" "Alpes-Isère" OFF \
        "LFLY" "Lyon" OFF \
        "LFLB" "Chambéry-Savoie" OFF \
        "LFST" "Strasbourg" OFF \
        "LFOT" "Tours Val de Loire" OFF \
        "LFSL" "Brive Souillac" OFF \
        "LFBE" "Bergerac" OFF 3>&1 1>&2 2>&3)
        selected=$(echo "$selected" | sed 's/"//g')
        selected=$(echo "$selected" | tr ' ' ',')
        sed -i "s/AIRPORTS=/\AIRPORTS=$selected \#/g" /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
     
        specific_airport=$(whiptail --title "Metar Info" --radiolist "Please specify the airport ICAO code for a default airport: " ${#airports} 27 78 20 \
        "LFPG" "Paris Charles de Gaulle" OFF \
        "LFPO" "Paris Orly" OFF \
        "LFOB" "Paris Beauvais" OFF \
        "LFBL" "Limoges Bellegarde" OFF \
        "LFMN" "Nice" OFF \
        "LFML" "Marseille" OFF \
        "LFBD" "Bordeaux" OFF \
        "LFRK" "Rouen" OFF \
        "LFRN" "Rennes" OFF \
        "LFRB" "Brest" OFF \
        "LFRS" "Nantes" OFF \
        "LFBO" "Toulouse" OFF \
        "LFMT" "Montpelier" OFF \
        "LFLC" "Clermont Ferrand" OFF \
        "LFLS" "Alpes-Isère" OFF \
        "LFLY" "Lyon" OFF \
        "LFLB" "Chambéry-Savoie" OFF \
        "LFST" "Strasbourg" OFF \
        "LFOT" "Tours Val de Loire" OFF \
        "LFSL" "Brive Souillac" OFF \
        "LFBE" "Bergerac" OFF 3>&1 1>&2 2>&3)
        specific_airport=$(echo "$specific_airport" | sed's/"//g')
        sed -i "s/\#STARTDEFAULT=EDDP/STARTDEFAULT=$specific_airport/g" /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        echo -e "$(date)" "${GREEN} $selected Aèroports inclu avec le défaut Aèroport $specific_airport ${NORMAL}" | tee -a /var/log/install.log
   
    else
     sed -i 's/,ModuleMetarInfo//' /etc/svxlink/svxlink.conf
    # removing MetarInfo from the MODULES= line in both SImplex and Duplex
    fi
}