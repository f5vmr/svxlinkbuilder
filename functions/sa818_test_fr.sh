#!/bin/bash
function sa818_test_fr {
if (whiptail --title "SA818 Vérification" --defaultno --yesno "Avez-vous un appareil SA818 installé comme émetteur-récepteur dans votre point d'accès ? Si ce n'est pas le cas, sélectionnez « Non », sinon sélectionnez « Oui »." 10 78); then
    sa818=true
else
    sa818=false
fi

}