#!/bin/bash

#Calling the functions.
source "${BASH_SOURCE%/*}/functions/sa818_test.sh"
sa818_test
if [[ $sa818 == true ]]; then
source "${BASH_SOURCE%/*}/functions/sa818_menu.sh"
sa818_menu
else
echo "No SA818 device"
fi

