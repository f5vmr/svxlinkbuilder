#!/bin/bash
## Set up echolink
function echolinksetup {
whiptail --title "Configurer EchoLink?" --yesno "Souhaitez-vous installer EchoLink et le configurer" 8 70 
if [ $? -eq "0" ] 
then
    ## "Installing echolink"
    sed -i 's/#MUTE_LOGIC/MUTE_LOGIC/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf      
        echocall=$(whiptail --title "Indicatif F2ABC-L or -R?" --inputbox "Selectionnez l'indicatif (-L or -R) qui sera memorisé" 8 60 3>&1 1>&2 2>&3)
        echocall=${echocall^^}
        echopass=$(whiptail --title "Mot-pass?" --passwordbox "Selectionnez le mot de pass" 8 20 3>&1 1>&2 2>&3)
        echosysop=$(whiptail --title "Prenom du System-Operateur?" --inputbox "Selectionnez le prenom du SYSOP" 8 20 3>&1 1>&2 2>&3)
        echosysop=${echosysop^}
        echofreq=$(whiptail --title "Frequence" --inputbox "Selectionnez la frequence sortie en MHz eg 145.2375" 8 20 3>&1 1>&2 2>&3)
        echolocation=$(whiptail --title "Endroit" --inputbox "Selectionnez la Ville ou le Dept." 8 20 3>&1 1>&2 2>&3)
        echolocation=${echolocation^}
    sed -i "s/CALLSIGN=MYCALL-L/CALLSIGN=$echocall/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/PASSWORD=MyPass/PASSWORD=$echopass/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyName/$echosysop/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/Fq,/$echofreq/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyTown/$echolocation/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/#DEFAULT_LANG=en_US/DEFAULT_LANG=fr_FR/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i 's/DESCRIPTION/#DESCRIPTION/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i 's/#STATUS_SERVER_LIST/STATUS_SERVER_LIST/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
 echo -e "$(date)" "${GREEN} Echolink est fonctionnel. ${NORMAL}" | tee -a /var/log/install.log
   
    else
     sed -i 's/,ModuleEchoLink//' /etc/svxlink/svxlink.conf
    # removing Echolink from the MODULES= line in both Simplex and Duplex
   echo -e "$(date)" "${YELLOW} EchoLink n'est pas disponible. ${NORMAL}" | tee -a /var/log/install.log

    fi
}