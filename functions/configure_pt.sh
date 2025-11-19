#!/bin/bash
function configure {
     file="/home/pi/svxlinkbuilder/functions/config.txt"
whiptail --title "SVXLink" --msgbox "$(cat $file)" 20 70 "OK" 2>&1 
}
