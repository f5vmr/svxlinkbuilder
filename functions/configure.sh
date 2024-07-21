#!/bin/bash
function configure {
     file="$HOME/svxlinkbuilder/functions/config.txt"
    echo "File path: $file"  # Debugging statement
    if [ -r "$file" ]; then
        echo "File is readable"   
whiptail --title "SVXLink" --msgbox "$(cat $file)" 20 70 "OK" 2>&1 
  else
        echo "Error: File $file not found or not readable"  # Error message
    fi
}