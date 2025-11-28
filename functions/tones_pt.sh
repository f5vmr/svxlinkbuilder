#!/bin/bash

function tones {
    if [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then

        LOGIC_DIR=/usr/share/svxlink/events.d/local
        RepeaterLogic="RepeaterLogicType.tcl"
        logicfile="$LOGIC_DIR/$RepeaterLogic"

        # ---------------------- First Menu ----------------------
        selected_option=$(whiptail --title "Select Repeater Sound Option" --menu "Choose a sound option:" 15 78 4 \
            "Bell Tone" "Escolhe esta opção para Default Bell Tone" \
            "Chime" "Escolhe esta opção para Mellow Chime " \
            "Pip" "Escolhe esta opção para Pip Tone" \
            "Silence" "Escolhe esta opção para No Idle Tone" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Bell Tone")
                    echo "Escolheste Bell Tone."
                ;;
                "Chime")
                    echo "Escolheste Chime."
                    sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
                ;;
                "Pip")
                    echo "Escolheste Pip."
                    sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^}/    CW::play "E";\n}/' "$logicfile"
                    sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^\s*playTone /#&/' "$logicfile";;
                ;;
                "Silence")
                    echo "Escolheste Silence."
                    sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
                    sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
                ;;
            esac
        else
            echo "Cancelado. Tons não alterados."
        fi

        # ---------------------- Closing Tone Menu ----------------------
        selected_option=$(whiptail --title "Opção para Som de feixo do Repetidor" --menu "Escolhe a opção:" 15 78 4 \
            "Default Tone" "Seleciona esta opção para Default Tone (Bi-Boop)" \
            "No Tone" "Just carrier shut-off" \
            "VA-Barred" "Seleciona esta opção para CW VA (...-.-) Tone" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Default Tone")
                    echo "Escolheste Bell Tone."
                ;;
                "No Tone")
                    echo "Escolheste carrier shut-off"
                    sed -i '89,92d' "$logicfile"
                ;;
                "VA-Barred")
                    echo "Escolheste CW VA-Barred."
                    sed -i '89,92c\CW::play "-";' "$logicfile"
                ;;
            esac
        else
            echo "Cancelado. Tons não alterados."
        fi

        # ---------------------- IDLE_TIMEOUT ----------------------
        get_idle_timeout() {
            grep -Po '(?<=^IDLE_TIMEOUT=).*' /etc/svxlink/svxlink.conf
        }

        update_idle_timeout() {
            sed -i "/^\[RepeaterLogic\]/,/^\[/ s/^IDLE_TIMEOUT=.*/IDLE_TIMEOUT=$1/" /etc/svxlink/svxlink.conf
        }

        current_idle_timeout=$(get_idle_timeout)

        new_idle_timeout=$(whiptail --title "Change IDLE_TIMEOUT (End of QSO)" \
            --inputbox "Current IDLE_TIMEOUT in secs : $current_idle_timeout\nEnter new IDLE_TIMEOUT:" \
            10 78 "$current_idle_timeout" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            update_idle_timeout "$new_idle_timeout"
            whiptail --title "Success" --msgbox "IDLE_TIMEOUT updated successfully to $new_idle_timeout." 8 78
        else
            whiptail --title "Canceled" --msgbox "No changes were made to IDLE_TIMEOUT." 8 78
        fi

        # ---------------------- CW.tcl patch ----------------------
        CWLogic="CW.tcl"
        cwfile="$LOGIC_DIR/$CWLogic"

        sudo sed -i '72a "-" "...-.-"' "$cwfile"
        sed -i 's/playTone 400 900 50/\#playTone 400 900 50/g' "$logicfile"
        sed -i 's/playTone 360 900 50/\#playTone 360 900 50/g' "$logicfile"
        sed -i 's/\#playTone 360 900 50/CW::play \"\-\"\;/' "$logicfile"

    else
        echo "NODE_OPTION is not 3 or 4. Skipping code..."
    fi
}
