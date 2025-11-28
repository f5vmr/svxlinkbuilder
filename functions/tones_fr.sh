#!/bin/bash

function tones {
    if [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then

        LOGIC_DIR=/usr/share/svxlink/events.d/local
        RepeaterLogic="RepeaterLogicType.tcl"
        logicfile="$LOGIC_DIR/$RepeaterLogic"

        #
        # -------------------------- MENU 1 --------------------------
        #

        selected_option=$(whiptail --title "Sélectionnez l'option du son du répéteur" --menu "Choisir une option de tonalité de relais:" 15 78 4 \
            "Ton de Cloche" "Sélectionnez cette option pour la tonalité de cloche par défaut" \
            "Carillon" "Sélectionnez cette option pour un carillon doux" \
            "Pip" "Sélectionnez cette option pour la tonalité pip" \
            "Silence" "Sélectionnez cette option pour désactiver la tonalité" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Ton de Cloche")
                    echo "Vous avez sélectionné le son cloche."
                ;;
                "Carillon")
                    echo "Vous avez sélectionné le son carillon."
                    sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
                ;;
                "Pip")
                    echo "You selected Pip."
                    sudo sed -i '/^proc repeater_idle {/,/^}/ {s/^\(\s*playTone.*\)$/#\1/}' "$logicfile"
                    sudo sed -i '/^proc repeater_idle {/,/^}/ {/^\}/i\  set iterations 0; set base 0;  CW::play "E";}' "$logicfile"
                ;;
                "Silence")
                    echo "Vous avez désactivé le son."
                    sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
                    sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
                ;;
            esac
        else
            echo "Annulation. Pas de changement de son."
        fi

        #
        # -------------------------- MENU 2 --------------------------
        #

        selected_option=$(whiptail --title "Repeater Close Option de son" --menu "Choose a sound option:" 15 78 4 \
            "Ton de defaut" "Sélectionnez cette option pour le ton par défaut (Bi-Boop)" \
            "Pas de Ton" "Fermeture sans ton" \
            "VA-Barré" "Sélectionné pour CW VA (...-.-) Ton" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Ton de defaut")
                    echo "Ton de défaut sélectionné."
                ;;
                "Pas de Ton")
                    echo "Fermeture sans ton sélectionnée."
                    sed -i '89,92d' "$logicfile"
                ;;
                "VA-Barré")
                    echo "VA-Barré sélectionné."
                    sed -i '89,92c\CW::play "-";' "$logicfile"
                ;;
            esac
        else
            echo "User cancelled selection."
        fi

        #
        # --------------------- IDLE_TIMEOUT SECTION ---------------------
        #

        get_idle_timeout() {
            grep -Po '(?<=^IDLE_TIMEOUT=).*' /etc/svxlink/svxlink.conf
        }

        update_idle_timeout() {
            sed -i "/^\[RepeaterLogic\]/,/^\[/ s/^IDLE_TIMEOUT=.*/IDLE_TIMEOUT=$1/" /etc/svxlink/svxlink.conf
        }

        current_idle_timeout=$(get_idle_timeout)

        new_idle_timeout=$(whiptail --title "Change IDLE_TIMEOUT (End of QSO)" \
            --inputbox "Current IDLE_TIMEOUT in secs : $current_
