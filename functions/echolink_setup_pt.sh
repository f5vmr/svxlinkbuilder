#!/bin/bash
## Set up echolink
function echolinksetup {
whiptail --title "Instalar EchoLink?" --yesno "Instala e configura o EchoLink" 8 78 
if [ $? -eq "0" ] 
then
    ## "Installing echolink"
    sed -i 's/\#MUTE_LOGIC/MUTE_LOGIC/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
        echocall=$(whiptail --title "Callsign A2ABC-L or -R?" --inputbox "Introduz o callsign (-L or -R) como registado no EchoLink" 8 78 3>&1 1>&2 2>&3)
        echocall=${echocall^^}
        echopass=$(whiptail --title "Password?" --passwordbox "Introduz a tua password do EchoLink" 8 78 3>&1 1>&2 2>&3)
        echosysop=$(whiptail --title "Nome do Operador do Sistema?" --inputbox "Introduz o nome do Operador" 8 78 3>&1 1>&2 2>&3)
        echosysop=${echosysop^}
        echofreq=$(whiptail --title "Frequencia" --inputbox "Intruduz a frequencia de TX em MHz exp. 145.2375" 8 78 3>&1 1>&2 2>&3)
        echolocation=$(whiptail --title "Localização" --inputbox "Introduz a tua Localização" 8 78 3>&1 1>&2 2>&3)
        echolocation=${echolocation^}
    sed -i "s/CALLSIGN=MYCALL-L/CALLSIGN=$echocall/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/PASSWORD=MyPass/PASSWORD=$echopass/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyName/$echosysop/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/Fq,/$echofreq/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyTown/$echolocation/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    #### The reverse to node_setup.sh where en_US is the default language
    if [[ "$lang" == "pt_PT" ]]; then
    sed -i "s/#DEFAULT_LANG=en_US/DEFAULT_LANG=$lang/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
fi
    #sed -i 's/DESCRIPTION/\#DESCRIPTION/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i 's/\#STATUS_SERVER_LIST/STATUS_SERVER_LIST/g' /etc/svxlink/svxlink.conf
echo -e "$(date)" "${GREEN} Echolink esta ativo ${NORMAL}" | sudo tee -a /var/log/install.log 
    else
     sed -i 's/,ModuleEchoLink//' /etc/svxlink/svxlink.conf
    # removing Echolink from the MODULES= line in both Simplex and Duplex
echo -e "$(date)" "${CYAN} EchoLink esta inativo ${NORMAL}" | sudo tee -a /var/log/install.log   
##nothing to do
    fi
}
