#!/bin/bash
## Set up echolink
function echolinksetup {
whiptail --title "Setup EchoLink?" --yesno "This will install EchoLink and configure it" 8 78 
if [ $? -eq "0" ] 
then
    ## "Installing echolink"
    sed -i 's/\#MUTE_LOGIC/MUTE_LOGIC/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
        echocall=$(whiptail --title "Callsign A2ABC-L or -R?" --inputbox "Enter your callsign (-L or -R) as registered" 8 78 3>&1 1>&2 2>&3)
        echocall=${echocall^^}
        echopass=$(whiptail --title "Password?" --passwordbox "Enter your EchoLink password" 8 78 3>&1 1>&2 2>&3)
        echosysop=$(whiptail --title "System Operator Name?" --inputbox "Enter your SYSOP Name" 8 78 3>&1 1>&2 2>&3)
        echosysop=${echosysop^}
        echofreq=$(whiptail --title "Frequency" --inputbox "Enter your Output frequency in MHz eg 145.2375" 8 78 3>&1 1>&2 2>&3)
        echolocation=$(whiptail --title "Location" --inputbox "Enter your location" 8 78 3>&1 1>&2 2>&3)
        echolocation=${echolocation^}
    sed -i "s/CALLSIGN=MYCALL-L/CALLSIGN=$echocall/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/PASSWORD=MyPass/PASSWORD=$echopass/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyName/$echosysop/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/Fq,/$echofreq/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyTown/$echolocation/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    #### The reverse to node_setup.sh where en_US is the default language
    if [[ "$lang" == "en_GB" ]]; then
    sed -i "s/#DEFAULT_LANG=en_US/DEFAULT_LANG=$lang/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
fi
    #sed -i 's/DESCRIPTION/\#DESCRIPTION/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i 's/\#STATUS_SERVER_LIST/STATUS_SERVER_LIST/g' /etc/svxlink/svxlink.conf
echo -e "$(date)" "${GREEN} Echolink is set up ${NORMAL}" | sudo tee -a /var/log/install.log > dev/null
    else
     sed -i 's/,ModuleEchoLink//' /etc/svxlink/svxlink.conf
    # removing Echolink from the MODULES= line in both Simplex and Duplex
echo -e "$(date)" "${CYAN} EchoLink is not set up ${NORMAL}" | sudo tee -a /var/log/install.log > dev/null    
##nothing to do
    fi
}