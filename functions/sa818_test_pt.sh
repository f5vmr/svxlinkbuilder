#!/bin/bash
function sa818_test {
if (whiptail --title "Verificação do dispositivo SA818" --defaultno --yesno "Tem um dispositivo SA818 instalado como transceptor no seu hotspot? Se não tiver, selecione 'Não'. Caso tenha, selecione 'Sim'." 10 78); then
    sa818=true
else
    sa818=false
fi

}
