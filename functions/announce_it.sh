#!/bin/bash
#### CW/Voice Announcements
function announce {
    CONF_DIR="/etc/svxlink"
    LOGIC_DIR="/usr/share/svxlink/events.d/local"
    logicfile="$LOGIC_DIR/Logic.tcl"
    svxconf_file="$CONF_DIR/svxlink.conf"
    echo -e "Utilizzo del modulo logico: $LOGIC_MODULE" | sudo tee -a /var/log/install.log

    #### CW TONE VARIABLES ####
    # Extract current values from the correct section
    cw_amp=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^CW_AMP *= *//p}" "$svxconf_file" | head -n 1)
    cw_pitch=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^CW_PITCH *= *//p}" "$svxconf_file" | head -n 1)
    cw_cpm=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^CW_CPM *= *//p}" "$svxconf_file" | head -n 1)
    short_ident_interval=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^SHORT_IDENT_INTERVAL *= *//p}" "$svxconf_file" | head -n 1)
    long_ident_interval=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^LONG_IDENT_INTERVAL *= *//p}" "$svxconf_file" | head -n 1)

    #echo -e "${CYAN}Current CW_AMP:${WHITE} $cw_amp"

    # Prompt user for new CW values
    new_cw_amp=$(whiptail --title "CW AMP" --inputbox \
        "Ampiezza CW attuale: $cw_amp dB\nInserisci un nuovo valore negativo per l'ampiezza CW (almeno -10 dB):" \
        10 78 -- "$cw_amp" 3>&1 1>&2 2>&3)
        # Ensure CW_AMP is negative
        # If user enters a positive number or zero, convert it to negative
        if [[ "$new_cw_amp" =~ ^[0-9]+$ ]]; then
            new_cw_amp="-$new_cw_amp"
        elif [[ "$new_cw_amp" =~ ^-?[0-9]+$ ]]; then
            # Already negative or zero; leave as-is
            :
        else
            # Not a number at all — fallback to previous value
            new_cw_amp="$cw_amp"
        fi

    new_cw_pitch=$(whiptail --title "Tono CW" --inputbox \
        "Frequenza del tono CW attuale: $cw_pitch Hz\nInserisci un nuovo valore per il tono CW (da 440 a 2200 Hz):" \
        10 78 -- "$cw_pitch" 3>&1 1>&2 2>&3)
    new_cw_cpm=$(whiptail --title "CW CPM" --inputbox \
        "Caratteri CW attuali al minuto: $cw_cpm\nInserisci un nuovo valore per CW CPM (da 60 a 200 caratteri al minuto):" \
        10 78 -- "$cw_cpm" 3>&1 1>&2 2>&3)


    # Prompt for Short/Long Ident Interval
    new_short_ident_interval=$(whiptail --title "Intervallo breve di identificazione" --menu \
        "Seleziona l'intervallo breve per l'identificazione periodica:" 15 78 5 \
        0 "Nessuno" 5 "5 minuti" 10 "10 minuti" 15 "15 minuti" 20 "20 minuti" 30 "30 Minuti" \
        3>&1 1>&2 2>&3)
    new_long_ident_interval=$(whiptail --title "Intervallo lungo di identificazione" --menu \
        "Seleziona l'intervallo lungo per l'identificazione periodica:" 15 78 4 \
        0 "Nessuno" 30 "30 minuti" 60 "60 minuti" 120 "120 minuti" \
        3>&1 1>&2 2>&3)

    echo -e "${YELLOW}Attendi le modifiche del modulo logico${WHITE}"

    #### LOGIC ID / ANNOUNCE FLAGS ####
    echo -e "${YELLOW}Lettura dei flag di abilitazione del modulo logico [$LOGIC_MODULE]...${WHITE}"

    # Helper to read values safely from the current section
    get_value_from_section() {
        local key="$1"
        sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{ s/^[[:space:]]*$key[[:space:]]*=[[:space:]]*//p }" "$svxconf_file" | head -n1
    }

    # Read existing values (default to 0 if not found)
    short_voice_id_enable=$(get_value_from_section "SHORT_VOICE_ID_ENABLE"); short_voice_id_enable=${short_voice_id_enable:-0}
    short_cw_id_enable=$(get_value_from_section "SHORT_CW_ID_ENABLE"); short_cw_id_enable=${short_cw_id_enable:-0}
    short_announce_enable=$(get_value_from_section "SHORT_ANNOUNCE_ENABLE"); short_announce_enable=${short_announce_enable:-0}
    long_voice_id_enable=$(get_value_from_section "LONG_VOICE_ID_ENABLE"); long_voice_id_enable=${long_voice_id_enable:-0}
    long_cw_id_enable=$(get_value_from_section "LONG_CW_ID_ENABLE"); long_cw_id_enable=${long_cw_id_enable:-0}
    long_announce_enable=$(get_value_from_section "LONG_ANNOUNCE_ENABLE"); long_announce_enable=${long_announce_enable:-0}

    # Prepare whiptail checklist options
    options=(
        "Abilita ID vocale breve" "" $( [ "$short_voice_id_enable" -eq 1 ] && echo "on" || echo "off" )
        "Abilita ID CW breve"    "" $( [ "$short_cw_id_enable" -eq 1 ] && echo "on" || echo "off" )
        "Abilita annuncio breve" "" $( [ "$short_announce_enable" -eq 1 ] && echo "on" || echo "off" )
        "Abilita ID vocale lungo"  "" $( [ "$long_voice_id_enable" -eq 1 ] && echo "on" || echo "off" )
        "Abilita ID CW lungo"     "" $( [ "$long_cw_id_enable" -eq 1 ] && echo "on" || echo "off" )
        "Abilita annuncio lungo"  "" $( [ "$long_announce_enable" -eq 1 ] && echo "on" || echo "off" )
    )

    # Display checklist to toggle values
    new_values=$(whiptail --title "Attiva o disattiva ID logico e opzioni di annuncio" --checklist \
        "Seleziona quali tipi di ID e annunci sono abilitati per [$LOGIC_MODULE]:" 18 78 6 \
        "${options[@]}" 3>&1 1>&2 2>&3)

    # Translate selections to 1/0
    new_short_voice_id_enable=$(echo "$new_values" | grep -q "Abilita ID vocale breve" && echo 1 || echo 0)
    new_short_cw_id_enable=$(echo "$new_values" | grep -q "Abilita ID CW breve" && echo 1 || echo 0)
    new_short_announce_enable=$(echo "$new_values" | grep -q "Abilita annuncio breve" && echo 1 || echo 0)
    new_long_voice_id_enable=$(echo "$new_values" | grep -q "Abilita ID vocale lungo" && echo 1 || echo 0)
    new_long_cw_id_enable=$(echo "$new_values" | grep -q "Abilita ID CW lungo" && echo 1 || echo 0)
    new_long_announce_enable=$(echo "$new_values" | grep -q "Abilita annuncio lungo" && echo 1 || echo 0)

    # Display confirmation
    echo -e "${CYAN}Abilita ID vocale breve:${WHITE} $new_short_voice_id_enable"
    echo -e "${CYAN}Abilita ID CW breve:${WHITE} $new_short_cw_id_enable"
    echo -e "${CYAN}Abilita annuncio breve:${WHITE} $new_short_announce_enable"
    echo -e "${CYAN}Abilita ID vocale lungo:${WHITE} $new_long_voice_id_enable"
    echo -e "${CYAN}Abilita ID CW lungo:${WHITE} $new_long_cw_id_enable"
    echo -e "${CYAN}Abilita annuncio lungo:${WHITE} $new_long_announce_enable"

    #### UPDATE SVXLINK.CONF FUNCTION ####
    update_svxlink_conf() {
        local conf="/etc/svxlink/svxlink.conf"
        local section="$LOGIC_MODULE"

        # Ensure the section header exists
        if ! grep -q "^\[$section\]" "$conf"; then
            echo -e "\n[$section]" | sudo tee -a "$conf" > /dev/null
        fi

        # Update or insert key=value inside section
        update_key() {
            local key="$1"
            local value="$2"
            if sudo sed -n "/^\[$section\]/,/^\[/{/^$key[[:space:]]*=/p}" "$conf" | grep -q .; then
                sudo sed -i "/^\[$section\]/,/^\[/{s|^$key[[:space:]]*=.*|$key=$value|}" "$conf"
            else
                sudo sed -i "/^\[$section\]/a$key=$value" "$conf"
            fi
        }

        # Update all parameters
        update_key "CW_AMP" "$new_cw_amp"
        update_key "CW_PITCH" "$new_cw_pitch"
        update_key "CW_CPM" "$new_cw_cpm"

        update_key "SHORT_IDENT_INTERVAL" "$new_short_ident_interval"
        update_key "SHORT_VOICE_ID_ENABLE" "$new_short_voice_id_enable"
        update_key "SHORT_CW_ID_ENABLE" "$new_short_cw_id_enable"
        update_key "SHORT_ANNOUNCE_ENABLE" "$new_short_announce_enable"

        update_key "LONG_IDENT_INTERVAL" "$new_long_ident_interval"
        update_key "LONG_VOICE_ID_ENABLE" "$new_long_voice_id_enable"
        update_key "LONG_CW_ID_ENABLE" "$new_long_cw_id_enable"
        update_key "LONG_ANNOUNCE_ENABLE" "$new_long_announce_enable"

        echo -e "${GREEN}Variabili di identificazione e CW aggiornate per [$section] in $conf${WHITE}"
    }

    # Call the update function
    update_svxlink_conf

    #### ROGER-BEEP SOUND SELECTION ####
    send_rgr_sound_content=$(sed -n '/proc send_rgr_sound/,/}/p' "$logicfile" | sed '1d;$d' | sed -n '/else/,/}/p' | sed '1d;$d')
    default_option="Beep"
    default_frequency=440
    default_volume=500
    default_duration=100

    if echo "$send_rgr_sound_content" | grep -q "playTone $default_frequency $default_volume $default_duration"; then
        default_option="Beep"
    elif echo "$send_rgr_sound_content" | grep -q 'CW::play " K"'; then
        default_option="Morse K"
    elif echo "$send_rgr_sound_content" | grep -q 'CW::play " T"'; then
        default_option="Morse T"
    elif echo "$send_rgr_sound_content" | grep -q 'CW::play ""'; then
        default_option="None"
    fi

    selected_option=$(whiptail --title "Seleziona il suono Roger-beep" --menu \
        "Scegli il suono del Roger-beep:" 15 78 4 \
        "Beep" "Beep predefinito" \
        "Morse K" "Suono Morse 'K'" \
        "Morse T" "Suono Morse 'T'" \
        "Nessuno" "Nessun suono" \
        3>&1 1>&2 2>&3)

    case $selected_option in
        "Beep")
            frequency=$(whiptail --title "Frequenza" --inputbox "Inserisci la frequenza (Hz):" 10 50 "$default_frequency" 3>&1 1>&2 2>&3)
            volume=$(whiptail --title "Volume" --inputbox "Inserisci il volume (0-100):" 10 50 "100" 3>&1 1>&2 2>&3)
            duration=$(whiptail --title "Durata" --inputbox "Inserisci la durata (ms):" 10 50 "$default_duration" 3>&1 1>&2 2>&3)
            sed -i "s/playTone [0-9]\+ [0-9]\+ [0-9]\+/playTone $frequency $volume $duration/g" "$logicfile"
            ;;
        "Morse K")
            sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play " K"/g' "$logicfile"
            ;;
        "Morse T")
            sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play " T"/g' "$logicfile"
            ;;
        "Nessuno")
            sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play ""/g' "$logicfile"
            ;;
    esac
}
