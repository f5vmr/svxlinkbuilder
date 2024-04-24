#!/bin/bash
LANG_OPTION=$(whiptail --title "Language Option" --menu "Select Language" 13 78 5 \
        "1" "English  United Kingdom en_GB" \
        "2" "Français   France fr_FR" \
        "3" "English  USA en_US" \
        "4" "Spanish (Spain) - es_ES" \
         3>&1 1>&2 2>&3 )

## Setting up Reflector
