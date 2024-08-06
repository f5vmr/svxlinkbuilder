#!/bin/bash
## Set up echolink
function echolinksetup {
whiptail --title "Setup EchoLink?" --yesno "Ceci va installer l'EchoLink et le configurer" 8 87 
if [ $? -eq "0" ] 
then
    ## "Installing echolink"
    sed -i 's/\#MUTE_LOGIC/MUTE_LOGIC/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf      
        echocall=$(whiptail --title "Indicatif F2ABC-L ou -R?" --inputbox "Selectionner l'indicatif (-L or -R) comme enregistré" 8 78 3>&1 1>&2 2>&3)
        echocall=${echocall^^}
        echopass=$(whiptail --title "Mot de passe?" --passwordbox "Entrer le mot de passe" 8 20 3>&1 1>&2 2>&3)
        echosysop=$(whiptail --title "Prenom de l'opérateur?" --inputbox "Indiquez votre prenom" 8 20 3>&1 1>&2 2>&3)
        echosysop=${echosysop^}
        echofreq=$(whiptail --title "Frequence" --inputbox "Indiquer La fréquence de sortie en MHz ex 145.2375" 8 20 3>&1 1>&2 2>&3)
        echolocation=$(whiptail --title "Ville" --inputbox "Indiquer la Ville ou le Dept." 8 20 3>&1 1>&2 2>&3)
        echolocation=${echolocation^}
    sed -i "s/CALLSIGN=MYCALL-L/CALLSIGN=$echocall/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/PASSWORD=MyPass/PASSWORD=$echopass/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyName/$echosysop/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/Fq,/$echofreq/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/MyTown/$echolocation/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i "s/\#DEFAULT_LANG=en_US/DEFAULT_LANG=fr_FR/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i 's/DESCRIPTION/\#DESCRIPTION/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sed -i 's/\#STATUS_SERVER_LIST/STATUS_SERVER_LIST/g' /etc/svxlink/svxlink.d/ModuleEchoLink.conf
 echo -e "$(date)" "${GREEN} Echolink est disponible. ${NORMAL}" | sudo tee -a /var/log/install.log
   
    else
     sed -i 's/,ModuleEchoLink//' /etc/svxlink/svxlink.conf
    # removing Echolink from the MODULES= line in both Simplex and Duplex
   echo -e "$(date)" "${CYAN} EchoLink n'est pas disponible. ${NORMAL}" | sudo tee -a /var/log/install.log

    fi
}
