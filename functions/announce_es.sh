#!/bin/bash
#### CW/Voice Announcements
function announce {
    CONF_DIR="/etc/svxlink"
    LOGIC_DIR="/usr/share/svxlink/events.d/local"
    logicfile="$LOGIC_DIR/Logic.tcl"
    svxconf_file="$CONF_DIR/svxlink.conf"
    echo "Using logic module: $LOGIC_MODULE" | sudo tee -a /var/log/install.log > /dev/null 

    #### CW TONE VARIABLES ####
    # Extract current values from the correct section
    cw_amp=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^CW_AMP *= *//p}" "$svxconf_file" | head -n 1)
    cw_pitch=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^CW_PITCH *= *//p}" "$svxconf_file" | head -n 1)
    cw_cpm=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^CW_CPM *= *//p}" "$svxconf_file" | head -n 1)
    short_ident_interval=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^SHORT_IDENT_INTERVAL *= *//p}" "$svxconf_file" | head -n 1)
    long_ident_interval=$(sed -n "/^\[$LOGIC_MODULE\]/,/^\[/{s/^LONG_IDENT_INTERVAL *= *//p}" "$svxconf_file" | head -n 1)

    echo -e "${CYAN}Current CW_AMP:${WHITE} $cw_amp" | sudo tee -a /var/log/install.log > /dev/null 

    # Prompt user for new CW values
    new_cw_amp=$(whiptail --title "CW AMP" --inputbox \
        "Current CW Amplitude: $cw_amp dB\nEnter new minus value for CW AMP (at least -10 dB):" \
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

    new_cw_pitch=$(whiptail --title "CW PITCH" --inputbox \
        "Current CW Tone Pitch: $cw_pitch Hz\nEnter new value for CW PITCH (440 to 2200 Hz):" \
        10 78 "$cw_pitch" 3>&1 1>&2 2>&3)
    new_cw_cpm=$(whiptail --title "CW CPM" --inputbox \
        "Current CW characters per minute: $cw_cpm\nEnter new value for CW CPM (60 to 200 Characters Per Minute):" \
        10 78 "$cw_cpm" 3>&1 1>&2 2>&3)

    # Prompt for Short/Long Ident Interval
    new_short_ident_interval=$(whiptail --title "SHORT IDENT INTERVAL" --menu \
        "Select SHORT Periodic Ident Interval:" 15 78 5 \
        0 "None" 5 "5 minutes" 10 "10 minutes" 15 "15 minutes" 20 "20 minutes" 30 "30 Minutes" \
        3>&1 1>&2 2>&3)
    new_long_ident_interval=$(whiptail --title "LONG IDENT INTERVAL" --menu \
        "Select LONG Periodic Ident Interval:" 15 78 4 \
        0 "None" 30 "30 minutes" 60 "60 minutes" 120 "120 minutes" \
        3>&1 1>&2 2>&3)
    echo "Short Ident Interval selected: $new_short_ident_interval" | sudo tee -a /var/log/install.log > /dev/null 
    echo "Long Ident Interval selected: $new_long_ident_interval" | sudo tee -a /var/log/install.log > /dev/null

    echo -e "${YELLOW}Standby for logic changes${WHITE}" | sudo tee -a /var/log/install.log > /dev/null 

    #### LOGIC ID / ANNOUNCE FLAGS ####
    echo -e "${YELLOW}Reading logic enable flags for [$LOGIC_MODULE]...${WHITE}" | sudo tee -a /var/log/install.log > /dev/null 

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
        "Short Voice ID Enable" "" $( [ "$short_voice_id_enable" -eq 1 ] && echo "on" || echo "off" )
        "Short CW ID Enable"    "" $( [ "$short_cw_id_enable" -eq 1 ] && echo "on" || echo "off" )
    #    "Short Announce Enable" "" $( [ "$short_announce_enable" -eq 1 ] && echo "on" || echo "off" )
        "Long Voice ID Enable"  "" $( [ "$long_voice_id_enable" -eq 1 ] && echo "on" || echo "off" )
        "Long CW ID Enable"     "" $( [ "$long_cw_id_enable" -eq 1 ] && echo "on" || echo "off" )
    #    "Long Announce Enable"  "" $( [ "$long_announce_enable" -eq 1 ] && echo "on" || echo "off" )
    )

    # Display checklist to toggle values
    new_values=$(whiptail --title "Toggle Logic ID & Announce Options" --checklist \
        "Select which ID and Announce types are enabled for [$LOGIC_MODULE]:" 18 78 6 \
        "${options[@]}" 3>&1 1>&2 2>&3)

    # Translate selections to 1/0
    new_short_voice_id_enable=$(echo "$new_values" | grep -q "Short Voice ID Enable" && echo 1 || echo 0)
    new_short_cw_id_enable=$(echo "$new_values" | grep -q "Short CW ID Enable" && echo 1 || echo 0)
    #new_short_announce_enable=$(echo "$new_values" | grep -q "Short Announce Enable" && echo 1 || echo 0)
    new_long_voice_id_enable=$(echo "$new_values" | grep -q "Long Voice ID Enable" && echo 1 || echo 0)
    new_long_cw_id_enable=$(echo "$new_values" | grep -q "Long CW ID Enable" && echo 1 || echo 0)
    #new_long_announce_enable=$(echo "$new_values" | grep -q "Long Announce Enable" && echo 1 || echo 0)

    # Display confirmation
    echo -e "${CYAN}Short Voice ID Enable:${WHITE} $new_short_voice_id_enable" | sudo tee -a /var/log/install.log > /dev/null 
    echo -e "${CYAN}Short CW ID Enable:${WHITE} $new_short_cw_id_enable" | sudo tee -a /var/log/install.log > /dev/null 
    echo -e "${CYAN}Short Announce Enable:${WHITE} $new_short_announce_enable" | sudo tee -a /var/log/install.log > /dev/null 
    echo -e "${CYAN}Long Voice ID Enable:${WHITE} $new_long_voice_id_enable" | sudo tee -a /var/log/install.log > /dev/null 
    echo -e "${CYAN}Long CW ID Enable:${WHITE} $new_long_cw_id_enable" | sudo tee -a /var/log/install.log > /dev/null 
    echo -e "${CYAN}Long Announce Enable:${WHITE} $new_long_announce_enable" | sudo tee -a /var/log/install.log > /dev/null 

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
     #   update_key "SHORT_ANNOUNCE_FILE" "$short_announce_file"

        update_key "LONG_IDENT_INTERVAL" "$new_long_ident_interval"
        update_key "LONG_VOICE_ID_ENABLE" "$new_long_voice_id_enable"
        update_key "LONG_CW_ID_ENABLE" "$new_long_cw_id_enable"
        update_key "LONG_ANNOUNCE_ENABLE" "$new_long_announce_enable"
     #   update_key "LONG_ANNOUNCE_FILE" "$long_announce_file"

        echo -e "${GREEN}Updated identification and CW variables for [$section] in $conf${WHITE}" | sudo tee -a /var/log/install.log > /dev/null 
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

    selected_option=$(whiptail --title "Select Roger-beep Sound" --menu \
        "Choose Roger-beep Sound:" 15 78 4 \
        "Beep" "Default beep" \
        "Morse K" "Morse 'K' sound" \
        "Morse T" "Morse 'T' sound" \
        "None" "No sound" \
        3>&1 1>&2 2>&3)

    case $selected_option in
        "Beep")
            frequency=$(whiptail --title "Frequency" --inputbox "Enter frequency (Hz):" 10 50 "$default_frequency" 3>&1 1>&2 2>&3)
            volume=$(whiptail --title "Volume" --inputbox "Enter volume (0-100):" 10 50 "100" 3>&1 1>&2 2>&3)
            duration=$(whiptail --title "Duration" --inputbox "Enter duration (ms):" 10 50 "$default_duration" 3>&1 1>&2 2>&3)
            sed -i "s/playTone [0-9]\+ [0-9]\+ [0-9]\+/playTone $frequency $volume $duration/g" "$logicfile"
            ;;
        "Morse K")
            sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play " K"/g' "$logicfile"
            ;;
        "Morse T")
            sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play " T"/g' "$logicfile"
            ;;
        "None")
            sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play ""/g' "$logicfile"
            ;;
    esac
}

