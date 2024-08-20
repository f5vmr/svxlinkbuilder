#!/bin/bash

#Calling the functions.
source "${BASH_SOURCE%/*}/functions/sa818_menu.sh"
sa818_menu
#source "${BASH_SOURCE%/*}/functions/sa818_prog.sh"
#sa818_prog

echo "$band SA818 device fitted and programmed to $selected_frequency "


