#!/bin/bash
## Set up echolink
function echolinksetup {
whiptail --title "Vuoi configurare EchoLink?" --defaultno --yesno "EchoLink sarà installato e configurato" 8 78
if [ $? -eq "0" ] 
then
    ## "Installing echolink"
    sed -i 's/\#MUTE_LOGIC/MUTE_LOGIC/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
        echocall=$(whiptail --title "Nominativo A2ABC-L o -R?" --inputbox "Inserisci il tuo nominativo (-L o -R) come registrato" 8 78 3>&1 1>&2 2>&3)
        echocall=${echocall^^}
        echopass=$(whiptail --title "Password?" --passwordbox "Inserisci la password di EchoLink" 8 78 3>&1 1>&2 2>&3)
        echosysop=$(whiptail --title "Nome del SYSOP?" --inputbox "Inserisci il nome del SYSOP" 8 78 3>&1 1>&2 2>&3)
        echosysop=${echosysop^}
        echofreq=$(whiptail --title "Frequenza" --inputbox "Inserisci la frequenza di trasmissione in MHz, ad esempio 145.2375" 8 78 3>&1 1>&2 2>&3)
        echolocation=$(whiptail --title "Località" --inputbox "Inserisci la tua località" 8 78 3>&1 1>&2 2>&3)
        echolocation=${echolocation^}
    sed -i "s/CALLSIGN=MYCALL-L/CALLSIGN=$echocall/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/PASSWORD=MyPass/PASSWORD=$echopass/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyName/$echosysop/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/Fq,/$echofreq/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyTown/$echolocation/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    #### The reverse to node_setup.sh where en_US is the default language
    if [[ "$lang" == "it_IT" ]]; then
    sed -i "s/#DEFAULT_LANG=en_US/DEFAULT_LANG=$lang/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
fi
    #sed -i 's/DESCRIPTION/\#DESCRIPTION/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i 's/\#STATUS_SERVER_LIST/STATUS_SERVER_LIST/g' /etc/svxlink/svxlink.conf
echo -e "$(date)" "${GREEN} EchoLink è stato configurato ${NORMAL}" | sudo tee -a /var/log/install.log 
    else
     sed -i 's/,ModuleEchoLink//' /etc/svxlink/svxlink.conf
    # removing Echolink from the MODULES= line in both Simplex and Duplex
echo -e "$(date)" "${CYAN} EchoLink non è stato configurato ${NORMAL}" | sudo tee -a /var/log/install.log    

##nothing to do
    fi
}
