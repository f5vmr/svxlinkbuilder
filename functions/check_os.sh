#!/bin/bash

function check_os {
    ## Retrieve the OS codename
    OS_name=$(lsb_release -c | grep -oP '(?<=Codename:\s)\w+')
    operating_system=$OS_name
    ## Check if the OS is Bookworm
    if [[ "$OS_name" != 'bookworm' ]] 
    then
        whiptail --scrolltext --title "SVXLink" --msgbox "This script is only for the Bookworm Linux distribution. Shutdown and Change to OS Bookworm, with user pi." 8 78
        
        echo -e "${RED} Closing down the script - Wrong OS ${NORMAL}" | sudo tee -a /etc/var/install.log
        sudo sh -c 'echo "sudo shutdown now" >> /etc/var/install.log"'
        exit 1  ## Exit the script if the OS is not Bookworm
    fi
    echo -e "${GREEN} #### OS is $operating_system #### ${NORMAL}" | sudo tee -a /var/log/install.log > dev/null
    }

