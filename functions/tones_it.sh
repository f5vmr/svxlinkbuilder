#!/bin/bash

function tones {
    if [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then

        LOGIC_DIR=/usr/share/svxlink/events.d/local
        RepeaterLogic="RepeaterLogicType.tcl"
        logicfile="$LOGIC_DIR/$RepeaterLogic"

        # ---------------------- Primo menu ----------------------
        selected_option=$(whiptail --title "Seleziona l'opzione audio del ripetitore" --menu "Scegli un'opzione audio:" 15 78 4 \
            "Campanello" "Seleziona questa opzione per il campanello predefinito" \
            "Melodia" "Seleziona questa opzione per una melodia delicata" \
            "Pip" "Seleziona questa opzione per il tono Pip" \
            "Silenzio" "Seleziona questa opzione per nessun tono" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Campanello")
                    echo "Hai selezionato campanello."
                ;;
                "Melodia")
                    echo "Hai selezionato melodia."
                    sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
                ;;
                "Pip")
                    echo "Hai selezionato Pip."
                    sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^\s*playTone /#&/' "$logicfile"
                    sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^}/    CW::play "E";\n}/' "$logicfile"
                ;;
                "Silenzio")
                    echo "Hai selezionato silenzio."
                    sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
                    sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
                ;;
            esac
        else
            echo "Hai annullato l'operazione. I toni non sono stati modificati."
        fi

        # ---------------------- Menu chiusura ripetitore ----------------------
        selected_option=$(whiptail --title "Seleziona l'opzione audio di chiusura del ripetitore" --menu "Scegli un'opzione audio:" 15 78 4 \
            "Tono predefinito" "Seleziona questa opzione per il tono predefinito (Bi-Boop)" \
            "Nessun tono" "Solo spegnimento portante" \
            "VA-Barred" "Seleziona questa opzione per il tono CW VA (...-.-)" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Tono predefinito")
                    echo "Hai selezionato il tono predefinito."
                ;;
                "Nessun tono")
                    echo "Hai selezionato lo spegnimento della portante."
                    sed -i '89,92d' "$logicfile"
                ;;
                "VA-Barred")
                    echo "Hai selezionato CW VA-Barred."
                    sed -i '89,92c\CW::play "-";' "$logicfile"
                ;;
            esac
        else
            echo "Selezione annullata dall'utente."
        fi

        # ---------------------- Gestione IDLE_TIMEOUT ----------------------
        get_idle_timeout() {
            grep -Po '(?<=^IDLE_TIMEOUT=).*' /etc/svxlink/svxlink.conf
        }

        update_idle_timeout() {
            sed -i "/^\[RepeaterLogic\]/,/^\[/ s/^IDLE_TIMEOUT=.*/IDLE_TIMEOUT=$1/" /etc/svxlink/svxlink.conf
        }

        current_idle_timeout=$(get_idle_timeout)

        new_idle_timeout=$(whiptail --title "Modifica IDLE_TIMEOUT (fine del QSO)" \
            --inputbox "Valore attuale di IDLE_TIMEOUT in secondi: $current_idle_timeout\nInserisci un nuovo IDLE_TIMEOUT:" \
            10 78 "$current_idle_timeout" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            update_idle_timeout "$new_idle_timeout"
            whiptail --title "Operazione riuscita" --msgbox "IDLE_TIMEOUT aggiornato a $new_idle_timeout." 8 78
        else
            whiptail --title "Annullato" --msgbox "Non sono state apportate modifiche a IDLE_TIMEOUT." 8 78
        fi

        # ---------------------- Patch CW.tcl ----------------------
        CWLogic="CW.tcl"
        cwfile="$LOGIC_DIR/$CWLogic"

        sudo sed -i '72a "-" "...-.-"' "$cwfile"
        sed -i 's/playTone 400 900 50/\#playTone 400 900 50/g' "$logicfile"
        sed -i 's/playTone 360 900 50/\#playTone 360 900 50/g' "$logicfile"
        sed -i 's/\#playTone 360 900 50/CW::play \"\-\"\;/' "$logicfile"

    else
        # Se NODE_OPTION non è 3 o 4
        echo "NODE_OPTION non è 3 o 4. Nessuna modifica applicata."
    fi
}
