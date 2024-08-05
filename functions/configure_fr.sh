#!/bin/bash
function configure_fr {
file="/home/pi/svxlinkbuilder/functions/config_fr.txt"
whiptail --title "SVXLink" --msgbox "$(cat $file)" 20 70 "OK" 2>&1 
}