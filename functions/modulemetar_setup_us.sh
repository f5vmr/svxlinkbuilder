#!/bin/bash
#### Metar Info ####
function modulemetar {
 
whiptail --title "Metar Info" --yesno "Do you wish to configure this module?" 8 78  3>&1 1>&2 2>&3
    if [ $? -eq "0" ] 
    then
        sleep 1
    selected=$(whiptail --title "Metar Info" --checklist "Choose which Airports: You can change them in the Dashboard" 24 78 17 \
        "KAIH" "Washington Dulles" OFF \
        "KATL" "Hartsfield-Jackson Atlanta" OFF \
        "KAUS" "Austin-Bergstrom" OFF \
        "KBNA" "Nashville International" OFF \
        "KBOS" "Boston Logan" OFF \
        "KBWI" "Baltimore-Washington" OFF \
        "KCLT" "Charlotte Douglas" OFF \
        "KDCA" "Ronald Reagan Washington" OFF \
        "KDEN" "Denver International" OFF \
        "KDFW" "Dallas-Fort Worth" OFF \
        "KDTW" "Detroit Metropolitan" OFF \
        "KEWR" "Newark Liberty" OFF \
        "KFLL" "Fort Lauderdale-Hollywood" OFF \
        "KIAH" "George Bush Intercontinental" OFF \
        "KJAC" "Jackson Hole" OFF \
        "KJFK" "John F. Kennedy International" OFF \
        "KLAS" "McCarran International" OFF \
        "KLAX" "Los Angeles International" OFF \
        "KLGA" "LaGuardia" OFF \
        "KMCO" "Orlando International" OFF \
        "KMIA" "Miami International" OFF \
        "KMSP" "Minneapolis-Saint Paul" OFF \
        "KORD" "Chicago O'Hare" OFF \
        "KPHL" "Philadelphia International" OFF \
        "KPHX" "Phoenix Sky Harbor" OFF \
        "KPIT" "Pittsburgh International" OFF \
        "KRDU" "Raleigh-Durham" OFF \
        "KSAN" "San Diego International" OFF \
        "KSEA" "Seattle-Tacoma International" OFF \
        "KSFO" "San Francisco International" OFF \
        "KSLC" "Salt Lake City International" OFF \
        "KTPA" "Tampa International"  OFF \
        "KTOL" "Toledo" OFF 3>&1 1>&2 2>&3)
        selected=$(echo "$selected" | sed 's/"//g')
        selected=$(echo "$selected" | tr ' ' ',')
        sed -i "s/AIRPORTS=.*/AIRPORTS=$selected/g"  /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
    sleep 5    
    specific_airport=$(whiptail --title "Metar Info" --radiolist "Please specify an ICAO code for a default airport: " 24 78 17 \
        "KAIH" "Washington Dulles" OFF \
        "KATL" "Hartsfield-Jackson Atlanta" OFF \
        "KAUS" "Austin-Bergstrom" OFF \
        "KBNA" "Nashville International" OFF \
        "KBOS" "Boston Logan" OFF \
        "KBWI" "Baltimore-Washington" OFF \
        "KCLT" "Charlotte Douglas" OFF \
        "KDCA" "Ronald Reagan Washington" OFF \
        "KDEN" "Denver International" OFF \
        "KDFW" "Dallas-Fort Worth" OFF \
        "KDTW" "Detroit Metropolitan" OFF \
        "KEWR" "Newark Liberty" OFF \
        "KFLL" "Fort Lauderdale-Hollywood" OFF \
        "KIAH" "George Bush Intercontinental" OFF \
        "KJAC" "Jackson Hole" OFF \
        "KJFK" "John F. Kennedy International" OFF \
        "KLAS" "McCarran International" OFF \
        "KLAX" "Los Angeles International" OFF \
        "KLGA" "LaGuardia" OFF \
        "KMCO" "Orlando International" OFF \
        "KMIA" "Miami International" OFF \
        "KMSP" "Minneapolis-Saint Paul" OFF \
        "KORD" "Chicago O'Hare" OFF \
        "KPHL" "Philadelphia International" OFF \
        "KPHX" "Phoenix Sky Harbor" OFF \
        "KPIT" "Pittsburgh International" OFF \
        "KRDU" "Raleigh-Durham" OFF \
        "KSAN" "San Diego International" OFF \
        "KSEA" "Seattle-Tacoma International" OFF \
        "KSFO" "San Francisco International" OFF \
        "KSLC" "Salt Lake City International" OFF \
        "KTPA" "Tampa International" OFF \
        "KTOL" "Toledo" OFF 3>&1 1>&2 2>&3)
        specific_airport=$(echo "$specific_airport" | sed 's/"//g')
        sed -i "s/\STARTDEFAULT=.*/STARTDEFAULT=$specific_airport/g" /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        echo -e "$(date)" "${GREEN} $selected Airports included with default Airport $specific_airport ${NORMAL}" | sudo tee -a /var/log/install.log  
    else
     sed -i 's/,ModuleMetarInfo//' /etc/svxlink/svxlink.conf
    # removing MetarInfo from the MODULES= line in both Simplex and Duplex
    fi
}