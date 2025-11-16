#!/bin/bash
function sa818_test {
if (whiptail --title "Controllo dispositivo SA818" --defaultno --yesno "Hai un dispositivo SA818 installato come ricetrasmettitore nel tuo hotspot? Se non ce l’hai, seleziona 'No', altrimenti seleziona 'Sì'." 10 78); then
    sa818=true
else
    sa818=false
fi

}
