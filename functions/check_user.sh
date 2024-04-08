#!/bin/bash
## Function to check the user

function usercheck {
    ## Get the current user
    current_user=$(logname) | tee -a   /var/log/install.log
    
    ## Check if the current user is 'pi'
   if [ "$logname" != "pi" ]; then 
   echo "Please the reform the SDcard as user pi" ; exit; 

    else whiptail --title "OS and user check" --msgbox "OS is $OS_name and User is $logname" 8 78;
fi
    echo -e "${GREEN} OS = $OS_name and Current user is $logname${NORMAL}" | tee -a  /var/log/install.log

}

