#!/bin/bash

function tones {
    if [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then
    
        LOGIC_DIR=/usr/share/svxlink/events.d/local
        RepeaterLogic="RepeaterLogicType.tcl"
        logicfile="$LOGIC_DIR/$RepeaterLogic"

        #
        # -------------------- MENÚ PRINCIPAL --------------------
        #

        selected_option=$(whiptail --title "Seleccione la opción de sonido del repetidor" --menu "Elige una opción de sonido:" 15 78 4 \
            "Tono Campana" "Tono de campana predeterminado" \
            "Timbre Suave" "Escuchar un timbre suave" \
            "Pip" "Tono pip" \
            "Silencio" "Sin tono inactivo" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in

                "Tono Campana")
                    echo "Has seleccionado Tono Campana."
                ;;

                "Timbre Suave")
                    echo "Has seleccionado Timbre Suave."
                    sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
                ;;

                "Pip")
                    echo "Has seleccionado Pip."
                    sudo sed -i '/^proc repeater_idle {/,/^}/ {s/^\(\s*playTone.*\)$/#\1/}' "$logicfile"
                    sudo sed -i '/^proc repeater_idle {/,/^}/ {/^\}/i\  set iterations 0; set base 0; CW::play "E";}' "$logicfile"
                ;;

                "Silencio")
                    echo "Has seleccionado Silencio."
                    sed -i 's/playTone 1100/#playTone 1100/g' "$logicfile"
                    sed -i 's/playTone 1200/#playTone 1200/g' "$logicfile"
                ;;

            esac
        else
            echo "Cancelado. No se modificaron los tonos."
        fi


        #
        # -------------------- MENÚ CIERRE REPETIDOR --------------------
        #

        selected_option=$(whiptail --title "Opción de sonido de cierre del repetidor" --menu "Elige una opción:" 15 78 4 \
            "Tono predeterminado" "Bi-Boop estándar" \
            "Sin tono" "Solo corte de portadora" \
            "VA-Unido" "Tono CW VA (...-.-)" \
            3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            case "$selected_option" in

                "Tono predeterminado")
                    echo "Has seleccionado el tono predeterminado."
                ;;

                "Sin tono")
                    echo "Cierre sin tono seleccionado."
                    sed -i '89,92d' "$logicfile"
                ;;

                "VA-Unido")
                    echo "VA-Unido seleccionado."
                    sed -i '89,92c\CW::play "-";' "$logicfile"
                ;;

            esac
        else
            echo "Selección cancelada."
        fi


        #
        # -------------------- IDLE_TIMEOUT --------------------
        #

        get_idle_timeout() {
            grep -Po '(?<=^IDLE_TIMEOUT=).*' /etc/svxlink/svxlink.conf
        }

        update_idle_timeout() {
            sed -i "/^\[RepeaterLogic\]/,/^\[/ s/^IDLE_TIMEOUT=.*/IDLE_TIMEOUT=$1/" /etc/svxlink/svxlink.conf
        }

        current_idle_timeout=$(get_idle_timeout)

        new_idle_timeout=$(whiptail --title "Cambiar IDLE_TIMEOUT (Fin de QSO)" \
            --inputbox "IDLE_TIMEOUT actual en segundos: $current_idle_timeout\nIntroduce nuevo valor:" \
            10 78 "$current_idle_timeout" 3>&1 1>&2 2>&3)

        if [ $? -eq 0 ]; then
            update_idle_timeout "$new_idle_timeout"
            whiptail --title "Éxito" --msgbox "IDLE_TIMEOUT actualizado correctamente a $new_idle_timeout." 8 78
        else
            whiptail --title "Cancelado" --msgbox "No se realizaron cambios." 8 78
        fi


        #
        # -------------------- PARCHES CW.tcl --------------------
        #

        CWLogic="CW.tcl"
        cwfile="$LOGIC_DIR/$CWLogic"

        sudo sed -i '72a "-" "...-.-"' "$cwfile"

        sed -i 's/playTone 400 900 50/#playTone 400 900 50/g' "$logicfile"
        sed -i 's/playTone 360 900 50/#playTone 360 900 50/g' "$logicfile"
        sed -i 's/#playTone 360 900 50/CW::play \"\-\"\;/' "$logicfile"


    else
        echo "NODE_OPTION no es 3 o 4. No se aplican cambios."
    fi
}
