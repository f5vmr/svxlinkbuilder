#!/bin/bash
#### Metar Info ####
function modulemetar {
 
whiptail --title "Información del medidor" --yesno "¿Desea configurar este módulo?" 8 78  3>&1 1>&2 2>&3
    if [ $? -eq "0" ] 
    then
        sleep 1
    selected=$(whiptail --title "Información del medidor" --checklist "Elija qué aeropuertos: Puedes cambiarlos en el tablero." 24 78 13 \
        "LECO"  "A Coruña " OFF \
        "LEAB"  "Albacete " OFF \
        "LEAL"  "Alicante-Elche " OFF \
        "LEAM"  "Almeria " OFF \
        "LEAS"  "Asterias " OFF \
        "LEBZ"  "Badajoz " OFF \
        "LEBL"  "Barcelona-El Prat " OFF \
        "LEBB"  "Bilbao " OFF \
        "LEBG"  "Burgos " OFF \
        "LEBA"  "Cordoba " OFF \
        "LEGE"  "Castellón-Costa-Azahar " OFF \
        "LEGR"  "Federico Garcia Lorca " OFF \
        "LEHC"  "Aragon " OFF \
        "LEJR"  "Jerez " OFF \
        "LESU"  "Andorra-La seu d'Urgell " OFF \
        "LELN"  "León " OFF \
        "LEMD"  "Madrid-Barajas " OFF \
        "LECU"  "Madrid-Cuatros Vientos " OFF \
        "LETO"  "Madrid-Torrejón " OFF \
        "LEMG"  "Malaga " OFF \
        "LEPP"  "Pamplona-Nóain " OFF \
        "LEMI"  "Mercia " OFF \
        "LERS"  "Reus " OFF \
        "LELL"  "Sabadell " OFF \
        "LESA"  "Salamanca " OFF \
        "LESO"  "Fuenterrabia " OFF \
        "LEXJ"  "Santander-Paravas " OFF \
        "LEST"  "Santiago de Compostella " OFF \
        "LEZL"  "Seville-San Pablo " OFF \
        "LETL"  "Teruel " OFF \
        "LEVC"  "Valencia " OFF \
        "LEVX"  "Vigo-Peindora " OFF \
        "LEVT"  "Vitoria-Foronda " OFF \
        "LEZG"  "Zaragoza " OFF \
        "LEPA"  "Palma " OFF \
        "LEMH"  "Menorca " OFF \
        "LEIB"  "Ibiza " OFF \
        "GCFV"  "Fuetaventura " OFF \
        "GCLP"  "Las Palmas GC " OFF \
        "GCTS"  "Tenerife Sud " OFF \
        "GCLA"  "La Palma " OFF \
        "GCHI"  "El Hierro " OFF 3>&1 1>&2 2>&3)
        selected=$(echo "$selected" | sed 's/"//g')
        selected=$(echo "$selected" | tr ' ' ',')
        sed -i "s/AIRPORTS=.*/AIRPORTS=$selected/g"  /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        sleep 5
        specific_airport=$(whiptail --title "Información del medidor" --radiolist "Especifique el código OACI del aeropuerto para un aeropuerto predeterminado: " 24 78 13 \
        "LECO"  "A Coruña " OFF \
        "LEAB"  "Albacete " OFF \
        "LEAL"  "Alicante-Elche " OFF \
        "LEAM"  "Almeria " OFF \
        "LEAS"  "Asterias " OFF \
        "LEBZ"  "Badajoz " OFF \
        "LEBL"  "Barcelona-El Prat " OFF \
        "LEBB"  "Bilbao " OFF \
        "LEBG"  "Burgos " OFF \
        "LEBA"  "Cordoba " OFF \
        "LEGE"  "Castellón-Costa-Azahar " OFF \
        "LEGR"  "Federico Garcia Lorca " OFF \
        "LEHC"  "Aragon " OFF \
        "LEJR"  "Jerez " OFF \
        "LESU"  "Andorra-La seu d'Urgell " OFF \
        "LELN"  "León " OFF \
        "LEMD"  "Madrid-Barajas " OFF \
        "LECU"  "Madrid-Cuatros Vientos " OFF \
        "LETO"  "Madrid-Torrejón " OFF \
        "LEMG"  "Malaga " OFF \
        "LEPP"  "Pamplona-Nóain " OFF \
        "LEMI"  "Mercia " OFF \
        "LERS"  "Reus " OFF \
        "LELL"  "Sabadell " OFF \
        "LESA"  "Salamanca " OFF \
        "LESO"  "Fuenterrabia " OFF \
        "LEXJ"  "Santander-Paravas " OFF \
        "LEST"  "Santiago de Compostella " OFF \
        "LEZL"  "Seville-San Pablo " OFF \
        "LETL"  "Teruel " OFF \
        "LEVC"  "Valencia " OFF \
        "LEVX"  "Vigo-Peindora " OFF \
        "LEVT"  "Vitoria-Foronda " OFF \
        "LEZG"  "Zaragoza " OFF \
        "LEPA"  "Palma " OFF \
        "LEMH"  "Menorca " OFF \
        "LEIB"  "Ibiza " OFF \
        "GCFV"  "Fuetaventura " OFF \
        "GCLP"  "Las Palmas GC " OFF \
        "GCTS"  "Tenerife Sud " OFF \
        "GCLA"  "La Palma " OFF \
        "GCHI"  "El Hierro " OFF 3>&1 1>&2 2>&3)
        specific_airport=$(echo "$specific_airport" | sed 's/"//g')
        sed -i "s/\STARTDEFAULT=.*/STARTDEFAULT=$specific_airport/g" /etc/svxlink/svxlink.d/ModuleMetarInfo.conf
        echo -e "$(date)" "${GREEN} $selected Aeropuertos incluidos con el aeropuerto predeterminado $specific_airport ${NORMAL}" | sudo tee -a /var/log/install.log > dev/null   
    else
     sed -i 's/,ModuleMetarInfo//' /etc/svxlink/svxlink.conf
    # removing MetarInfo from the MODULES= line in both Simplex and Duplex
    fi
}