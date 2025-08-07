#!/bin/bash
## Set up echolink
function echolinksetup {
whiptail --title "Para configurar-EchoLink?" --yesno "Esto instalará EchoLink y lo configurará." 8 78 
if [ $? -eq "0" ] 
then
    ## "Installing echolink"
    #sed -i "s/\#MUTE_LOGIC/MUTE_LOGIC/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
        echocall=$(whiptail --title "¿Indicativo EA2ABC-L or -R?" --inputbox "Ingrese su indicativo (-L o -R) como registrado" 8 78 3>&1 1>&2 2>&3)
        echocall=${echocall^^}
        echopass=$(whiptail --title "¿Contraseña?" --passwordbox "Ingrese su contraseña de EchoLink" 8 78 3>&1 1>&2 2>&3)
        echosysop=$(whiptail --title "¿Nombre del operador del sistema?" --inputbox "Ingrese su nombre de operador del sistema" 8 78 3>&1 1>&2 2>&3)
        echosysop=${echosysop^}
        echofreq=$(whiptail --title "Frecuencia" --inputbox "Ingrese su frecuencia de salida en MHz, por ejemplo, 145.2375" 8 78 3>&1 1>&2 2>&3)
        echolocation=$(whiptail --title "Ubicación" --inputbox "Ingresa tu ubicación" 8 78 3>&1 1>&2 2>&3)
        echolocation=${echolocation^}
    sudo sed -i "s/CALLSIGN=MYCALL-L/CALLSIGN=$echocall/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sudo sed -i "s/PASSWORD=MyPass/PASSWORD=$echopass/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sudo sed -i "s/MyName/$echosysop/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sudo sed -i "s/Fq,/$echofreq/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sudo sed -i "s/MyTown/$echolocation/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sudo sed -i "s/\#DEFAULT_LANG=en_US/DEFAULT_LANG=es_ES/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    #sed -i "s/DESCRIPTION/\#DESCRIPTION/g" /etc/svxlink/svxlink.d/ModuleEchoLink.conf
    sudo sed -i 's/\#STATUS_SERVER_LIST/STATUS_SERVER_LIST/g' /etc/svxlink/svxlink.conf
echo -e "$(date)" "${GREEN} Echolink is set up ${NORMAL}" | sudo tee -a /var/log/install.log

    else
     sudo sed -i 's/,ModuleEchoLink//' /etc/svxlink/svxlink.d/$NODE
    # removing Echolink from the MODULES= line in both Simplex and Duplex
echo -e "$(date)" "${CYAN} EchoLink no está configurado ${NORMAL}" | sudo tee -a /var/log/install.log
    ##nothing to do
    fi
}