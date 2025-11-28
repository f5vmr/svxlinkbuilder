#!/bin/bash

function tones {
    if [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then

        LOGIC_DIR=/usr/share/svxlink/events.d/local
        RepeaterLogic="RepeaterLogicType.tcl"
        logicfile="$LOGIC_DIR/$RepeaterLogic"

        # ---------------------- First menu ----------------------
        selected_option=$(whiptail --title "Select Repeater Sound Option" --menu "Choose a sound option:" 15 78 4 \
            "Bell Tone" "Select this option for Default Bell Tone" \
            "Chime" "Select this option for Mellow Chime " \
            "Pip" "Select this option for Pip Tone" \
            "Silence" "Select this option for No Idle Tone" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Bell Tone")
                    echo "You selected Bell Tone."
                ;;
                "Chime")
                    echo "You selected Chime."
                    sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
                ;;
                "Pip")
                    echo "You selected Pip."
                    
                sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^}/    CW::play "E";\n}/' "$logicfile"
                sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^\s*playTone /#&/' "$logicfile";;
                "Silence")
                    echo "You selected Silence."
                    sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
                    sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
                ;;
            esac
        else
            echo "You cancelled. Tones not changed."
        fi

        # ---------------------- Repeater Close Menu ----------------------
        selected_option=$(whiptail --title "Repeater Close Sound Option" --menu "Choose a sound option:" 15 78 4 \
            "Default Tone" "Select this option for Default Tone (Bi-Boop)" \
            "No Tone" "Just carrier shut-off" \
            "VA-Barred" "Select this option for CW VA (...-.-) Tone" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in
                "Default Tone")
                    echo "You selected Bell Tone."
                ;;
                "No Tone")
                    echo "You selected carrier shut-off"
                    sed -i '89,92d' "$logicfile"
                ;;
                "VA-Barred")
                    echo "You selected CW VA-Barred."
                    sed -i '89,92c\CW::play "-";' "$logicfile"
                ;;
            esac
        else
            echo "User cancelled selection."
        fi

        # ---------------------- IDLE_TIMEOUT update ----------------------
        get_idle_timeout() {
            grep -Po '(?<=^IDLE_TIMEOUT=).*' /etc/svxlink/svxlink.conf
        }

        update_idle_timeout() {
            sed -i "/^\[RepeaterLogic\]/,/^\[/ s/^IDLE_TIMEOUT=.*/IDLE_TIMEOUT=$1/" /etc/svxlink/svxlink.conf
        }

        current_idle_timeout=$(get_idle_timeout)

        new_idle_timeout=$(whiptail --title "Change IDLE_TIMEOUT (End of QSO)" --inputbox "Current IDLE_TIMEOUT in secs : $current_idle_timeout\nEnter new IDLE_TIMEOUT:" 10 78 "$current_idle_timeout" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            update_idle_timeout "$new_idle_timeout"
            whiptail --msgbox "IDLE_TIMEOUT updated to $new_idle_timeout." 8 78
        else
            whiptail --msgbox "No changes made." 8 78
        fi

        # ---------------------- CW.tcl patching ----------------------
        cwfile="$LOGIC_DIR/CW.tcl"
        sudo sed -i '72a "-" "...-.-"' "$cwfile"
        sed -i 's/playTone 400 900 50/\#playTone 400 900 50/g' "$logicfile"
        sed -i 's/playTone 360 900 50/\#playTone 360 900 50/g' "$logicfile"
        sed -i 's/\#playTone 360 900 50/CW::play \"\-\"\;/' "$logicfile"

    else
        echo "NODE_OPTION is not 3 or 4. Skipping code..."
    fi
}
