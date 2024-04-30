#!/bin/bash
CONF_DIR="/etc/svxlink"
LOGIC_DIR="/usr/share/svxlink/events.d/local"
svxfile="svxlink.conf"
logictcl="Logic.tcl"
logicfile="$LOGIC_DIR/$logictcl"
svxconf_file="$CONF_DIR/$svxfile"

# Extract current values of SHORT_IDENT_INTERVAL and LONG_IDENT_INTERVAL from svxlink.conf
short_ident_interval=$(grep "^SHORT_IDENT_INTERVAL" $svxconf_file | awk -F '=' '{print $2}' | tr -d ' ')
long_ident_interval=$(grep "^LONG_IDENT_INTERVAL" $svxconf_file | awk -F '=' '{print $2}' | tr -d ' ')

# Display current values and prompt for new values using whiptail
new_values=$(whiptail --title "Ident Intervals" --inputbox "Current SHORT_IDENT_INTERVAL: $short_ident_interval\nCurrent LONG_IDENT_INTERVAL: $long_ident_interval\n\nEnter new values for both parameters separated by space:" 15 78 "$short_ident_interval $long_ident_interval" 3>&1 1>&2 2>&3)

# Extract new values
new_short_ident_interval=$(echo "$new_values" | awk '{print $1}')
new_long_ident_interval=$(echo "$new_values" | awk '{print $2}')

# Update svxlink.conf with new values
sed -i 's/^SHORT_IDENT_INTERVAL=.*/SHORT_IDENT_INTERVAL="$new_short_ident_interval"/g' "$svxconf_file"
sed -i 's/^LONG_IDENT_INTERVAL=.*/LONG_IDENT_INTERVAL="$new_long_ident_interval"/g' "$svxconf_file"


# Extract current values of the variables
short_voice_id_enable=$(grep "variable short_voice_id_enable" "$logicfile" | awk '{print $3}')
short_cw_id_enable=$(grep "variable short_cw_id_enable" "$logicfile" | awk '{print $3}')
long_voice_id_enable=$(grep "variable long_voice_id_enable" "$logicfile" | awk '{print $3}')
long_cw_id_enable=$(grep "variable long_cw_id_enable" "$logicfile" | awk '{print $3}')

# Display current values and prompt for new values using whiptail
new_values=$(whiptail --title "Toggle ID Variables" --checklist "Toggle Variables" 15 60 4 \
    "short_voice_id_enable" "SHORT_VOICE_ID_ENABLE: $short_voice_id_enable" $short_voice_id_enable \
    "short_cw_id_enable" "SHORT_CW_ID_ENABLE: $short_cw_id_enable" $short_cw_id_enable \
    "long_voice_id_enable" "LONG_VOICE_ID_ENABLE: $long_voice_id_enable" $long_voice_id_enable \
    "long_cw_id_enable" "LONG_CW_ID_ENABLE: $long_cw_id_enable" $long_cw_id_enable \
    3>&1 1>&2 2>&3)

# Extract new values
new_short_voice_id_enable=$(echo "$new_values" | grep "short_voice_id_enable" | wc -l)
new_short_cw_id_enable=$(echo "$new_values" | grep "short_cw_id_enable" | wc -l)
new_long_voice_id_enable=$(echo "$new_values" | grep "long_voice_id_enable" | wc -l)
new_long_cw_id_enable=$(echo "$new_values" | grep "long_cw_id_enable" | wc -l)

# Update Logic.tcl with the new values
sed -i 's/variable short_voice_id_enable $short_voice_id_enable/variable short_voice_id_enable "$new_short_voice_id_enable"/g' "$logicfile"
sed -i 's/variable short_cw_id_enable $short_cw_id_enable/variable short_cw_id_enable "$new_short_cw_id_enable"/g' "$logicfile"
sed -i 's/variable long_voice_id_enable $long_voice_id_enable/variable long_voice_id_enable "$new_long_voice_id_enable"/g' "$logicfile"
sed -i 's/variable long_cw_id_enable $long_cw_id_enable/variable long_cw_id_enable "$new_long_cw_id_enable"/g' "$logicfile"



# Extract the content of the send_rgr_sound procedure
send_rgr_sound_content=$(sed -n '/proc send_rgr_sound/,/}/p' "$logicfile" | sed '1d;$d' | sed -n '/else/,/}/p' | sed '1d;$d')

# Default settings
default_option="Beep"
default_frequency=440
default_volume=500
default_duration=100

# Check if the content contains the default playTone line
if echo "$send_rgr_sound_content" | grep -q "playTone $default_frequency $default_volume $default_duration"; then
    # Default setting is a beep
    default_option="Beep"
elif echo "$send_rgr_sound_content" | grep -q "CW::play \"K\""; then
    # Default setting is Morse "K"
    default_option="Morse K"
elif echo "$send_rgr_sound_content" | grep -q "CW::play \"T\""; then
    # Default setting is Morse "T"
    default_option="Morse T"
fi

# Display options and prompt for selection using whiptail
selected_option=$(whiptail --title "Select Roger-beep Sound" --menu "Choose Roger-beep Sound:" 15 78 3 \
    "Beep" "Default beep" \
    "Morse K" "Morse 'K' sound" \
    "Morse T" "Morse 'T' sound" \
    3>&1 1>&2 2>&3)

# Update Logic.tcl with the selected option
case $selected_option in
    "Beep")
        # Prompt for frequency, volume, and duration if "Beep" is selected
        frequency=$(whiptail --title "Frequency" --inputbox "Enter frequency (Hz):" 10 50 "$frequency" 3>&1 1>&2 2>&3)
        volume=$(whiptail --title "Volume" --inputbox "Enter volume (0-100):" 10 50 "100" 3>&1 1>&2 2>&3)
        duration=$(whiptail --title "Duration" --inputbox "Enter duration (ms):" 10 50 "$default_duration" 3>&1 1>&2 2>&3)
        # Update Logic.tcl with the entered frequency, volume, and duration
        sed -i "s/playTone [0-9]\+ [0-9]\+ [0-9]\+/playTone $frequency $volume $duration/g" "$svxconf_file"
        ;;
    "Morse K")
        sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play " K"/g' "$svxconf_file"
        ;;
    "Morse T")
        sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play " T"/g' "$svxconf_file"
        ;;
esac
#### now the Morse tone and speed.
 # Extract current values of CW_AMP, CW_PITCH, and CW_CPS

cw_amp=$(grep -E "^CW_AMP" "$svxconf_file" | awk -F '=' '{print $2}' | tr -d ' ')
cw_pitch=$(grep -E "^CW_PITCH" "$svxconf_file" | awk -F '=' '{print $2}' | tr -d ' ')
cw_cpm=$(grep -E "^CW_CPM" "$svxconf_file" | awk -F '=' '{print $2}' | tr -d ' ')

# Calculate display volume as positive integer
display_cw_amp=$(( 0 - cw_amp ))

# Default values
default_cw_amp=0
default_cw_pitch=650
default_cw_cpm=95

# Display options and prompt for selection using whiptail
selected_cw_amp=$(whiptail --title "CW Pitch and Speed" --inputbox "Enter Volume (0 to 10 dB):" 15 78 "$display_cw_amp" 3>&1 1>&2 2>&3)
selected_cw_amp=$(( 0 - selected_cw_amp ))  # Convert back to negative integer

selected_cw_pitch=$(whiptail --title "CW Pitch and Speed" --inputbox "Enter Tone (600-1800 Hz):" 15 78 "$cw_pitch" 3>&1 1>&2 2>&3)
selected_cw_cpm=$(whiptail --title "CW Pitch and Speed" --inputbox "Enter Speed (75-200):" 15 78 "$cw_cpm" 3>&1 1>&2 2>&3)

# Update svxlink.conf with the selected values
sed -i 's/^CW_AMP=.*/CW_AMP="$selected_cw_amp"/g' "$svxconf_file"
sed -i 's/^CW_PITCH=.*/CW_PITCH="$selected_cw_pitch"/g' "$svxconf_file"
sed -i 's/^CW_CPM=.*/CW_CPM="$selected_cw_cpm"/g' "$svxconf_file"



