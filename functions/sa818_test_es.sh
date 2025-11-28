#!/bin/bash
function sa818_test_es {
if (whiptail --title "SA818 Device Check" --defaultno --yesno "¿Tiene un dispositivo SA818 instalado como transceptor en su punto de acceso? Si no, seleccione "No"; de lo contrario, seleccione "Sí"." 10 78); then
    sa818=true
else
    sa818=false
fi

}