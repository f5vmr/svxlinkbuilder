#!/bin/bash

CONF_DIR="/etc/svxlink"
LOGIC_DIR=/usr/share/svxlink/events.d/local
logicfile="$LOGIC_DIR/Logic.tcl"
svxconf_file="$CONF_DIR/svxlink.conf"

#### CW TONE VARIABLES #### IDENTS ####
# Extract numerical variables from svxlink.conf
cw_amp=$(grep -E "CW_AMP" "$svxconf_file" ) #| awk -F '=' '{print $2}' | tr -d ' ')
cw_pitch=$(grep -E "CW_PITCH" "$svxconf_file" ) # | awk -F '=' '{print $2}' | tr -d ' ')
cw_cpm=$(grep -E "CW_CPM" "$svxconf_file" ) #| awk -F '=' '{print $2}' | tr -d ' ')
short_ident_interval=$(grep -E "SHORT_IDENT_INTERVAL" "$svxconf_file" ) #| awk -F '=' '{print $2}' | tr -d ' ')
long_ident_interval=$(grep -E "LONG_IDENT_INTERVAL" "$svxconf_file" ) #| awk -F '=' '{print $2}' | tr -d ' ')

# Ensure cw_amp is within the specified range
#if [[ "$cw_amp" -gt 0 && "$cw_amp" -lt -10 ]]; then
#    echo "Error: CW_AMP value is not within the specified range (0 to -10 dB)"
#    exit 1
#fi
#echo -e "${CYAN}Current CW_AMP:${WHITE} $cw_amp"
# Prompt the user to input new values for each parameter using whiptail
# new_cw_amp=$(whiptail --title "CW AMP" --inputbox "Current CW Amplitude: $cw_amp dB\nEnter new value for CW AMP (0 to -10 dB):" 10 78 "$cw_amp" 3>&1 1>&2 2>&3)
# Prompt the user for input within the specified range
# Validate the current CW AMP value
# Validate the current CW AMP value
new_cw_amp=$(whiptail --title "CW AMP" --inputbox "Current CW Amplitude: $cw_amp dB\nEnter new value for CW AMP (0 to -10 dB):" 10 78 --nocancel 3>&1 1>&2 2>&3)
new_cw_pitch=$(whiptail --title "CW PITCH" --inputbox "Current CW Tone Pitch: $cw_pitch Hz\nEnter new value for CW PITCH (440 to 2200 Hz):" 10 78 --nocancel 3>&1 1>&2 2>&3)
new_cw_cpm=$(whiptail --title "CW CPM" --inputbox "Current CW characters per minute: $cw_cpm \nEnter new value for CW CPM (60 to 200 Characters Per Minute):" 10 78 --nocancel 3>&1 1>&2 2>&3)
new_short_ident_interval=$(whiptail --title "SHORT IDENT INTERVAL" --menu "Select SHORT Periodic  Ident Interval:" 15 78 5 0 "None" 5 "5 minutes" 10 "10 minutes" 15 "15 minutes" 20 "20 minutes" 30 "30 Minutes" 3>&1 1>&2 2>&3)
new_long_ident_interval=$(whiptail --title "LONG IDENT INTERVAL" --menu "Select LONG Periodic Ident Interval:" 15 78 4 0 "None" 30 "30 minutes" 60 "60 minutes" 120 "120 minutes" 3>&1 1>&2 2>&3)

# Replace the existing parameters with the user's new values using sed with double quotes as delimiters
# echo -e "${CYAN}Replacing CW_AMP with ${WHITE} $new_cw_amp"
# Escape the minus sign in $new_cw_amp


# Update svxlink.conf with the new values for CW_AMP
# Update svxlink.conf with the new values for CW_AMP
# Update svxlink.conf with the new values for CW_AMP using a different delimiter
# Update svxlink.conf with the new values for CW_AMP with the replacement value enclosed in double quotes
#sed -i "s/^CW_AMP=.*/CW_AMP=\"$new_cw_amp\"/g" -- "$svxconf_file"
# Update svxlink.conf with the new value for CW_AMP using awk
sed -i "s|^CW_AMP=.*|CW_AMP=$new_cw_amp|g" "$svxconf_file"
#echo -e "${CYAN}Replacing CW_PITCH with ${WHITE} $new_cw_pitch"
sed -i "s|^CW_PITCH=.*|CW_PITCH=$new_cw_pitch|g" "$svxconf_file"
#echo -e "${CYAN}Replacing CW_CPM with ${WHITE} $new_cw_cpm"
sed -i "s|^CW_CPM=.*|CW_CPM=$new_cw_cpm|g" "$svxconf_file"
#echo -e "${CYAN}Replacing SHORT_IDENT_INTERVAL with ${WHITE} $new_short_ident_interval"
sed -i "s|^SHORT_IDENT_INTERVAL=.*|SHORT_IDENT_INTERVAL=$new_short_ident_interval|g" "$svxconf_file"
#echo -e "${CYAN}Replacing LONG_IDENT_INTERVAL with ${WHITE} $new_long_ident_interval"
sed -i "s|^LONG_IDENT_INTERVAL=.*|LONG_IDENT_INTERVAL=$new_long_ident_interval|g" "$svxconf_file"
#echo -e "${YELLOW}Standby for logic changes ${WHITE}"
#### LOGIC CHANGES ####
## Extract the values of the text indicators from Logic.tcl
# Retrieve the current values of the variables
short_voice_id_enable=$(head -n 40 "$logicfile" | awk '/^variable short_voice_id_enable/{print $NF; exit}')
short_cw_id_enable=$(head -n 40 "$logicfile" | awk '/^variable short_cw_id_enable/{print $NF; exit}')
long_voice_id_enable=$(head -n 40 "$logicfile" | awk '/^variable long_voice_id_enable/{print $NF; exit}')
long_cw_id_enable=$(head -n 40 "$logicfile" | awk '/^variable long_cw_id_enable/{print $NF; exit}')

# Define the options for the checklist dialog
options=(
    "Short Voice ID Enable" "$short_voice_id_enable" ""  # Empty description for now
    "Short CW ID Enable" "$short_cw_id_enable" ""        # Empty description for now
    "Long Voice ID Enable" "$long_voice_id_enable" ""    # Empty description for now
    "Long CW ID Enable" "$long_cw_id_enable" ""          # Empty description for now
)

# Add descriptions to the options based on their current values
for ((i = 0; i < ${#options[@]}; i+=3)); do
    value="${options[i+1]}"
    if [ "$value" == "1" ]; then
        options[i+2]="Enabled"
    else
        options[i+2]="Disabled"
    fi
done

# Prompt the user to toggle the variables using a checklist dialog
new_values=$(whiptail --title "Toggle Logic Timing Variables" --checklist "Toggle Variables" 15 78 4 "${options[@]}" 3>&1 1>&2 2>&3)

# Extract the new values from the checklist dialog
new_short_voice_id_enable=$(echo "$new_values" | grep -o "Short Voice ID Enable" | wc -l)
new_short_cw_id_enable=$(echo "$new_values" | grep -o "Short CW ID Enable" | wc -l)
new_long_voice_id_enable=$(echo "$new_values" | grep -o "Long Voice ID Enable" | wc -l)
new_long_cw_id_enable=$(echo "$new_values" | grep -o "Long CW ID Enable" | wc -l)
echo -e "${CYAN}Short Voice ID Enable:${WHITE} $new_short_voice_id_enable"
echo -e "${CYAN}Short CW ID Enable:${WHITE} $new_short_cw_id_enable"
echo -e "${CYAN}Long Voice ID Enable:${WHITE} $new_long_voice_id_enable"
echo -e "${CYAN}Long CW ID Enable:${WHITE} $new_long_cw_id_enable"


# Update the Logic.tcl file with the new values
sed -i "s/^\(variable short_voice_id_enable\s*\)[0-9].*/\1$new_short_voice_id_enable/g" "$logicfile"
sed -i "s/^\(variable short_cw_id_enable\s*\)[0-9].*/\1$new_short_cw_id_enable/g" "$logicfile"
sed -i "s/^\(variable long_voice_id_enable\s*\)[0-9].*/\1$new_long_voice_id_enable/g" "$logicfile"
sed -i "s/^\(variable long_cw_id_enable\s*\)[0-9].*/\1$new_long_cw_id_enable/g" "$logicfile"


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
elif echo "$send_rgr_sound_content" | grep -q "CW::play \" K\""; then
    # Default setting is Morse "K"
    default_option="Morse K"
elif echo "$send_rgr_sound_content" | grep -q "CW::play \" T\""; then
    # Default setting is Morse "T"
    default_option="Morse T"
elif echo "$send_rgr_sound_content" | grep -q "CW::play \"\""; then
    # Default setting is Morse ""
    default_option="None"
fi

# Display options and prompt for selection using whiptail
selected_option=$(whiptail --title "Select Roger-beep Sound" --menu "Choose Roger-beep Sound:" 15 78 4 \
    "Beep" "Default beep" \
    "Morse K" "Morse 'K' sound" \
    "Morse T" "Morse 'T' sound" \
    "None" "No sound" \
    3>&1 1>&2 2>&3)

# Update Logic.tcl with the selected option
case $selected_option in
    "Beep")
        # Prompt for frequency, volume, and duration if "Beep" is selected
        frequency=$(whiptail --title "Frequency" --inputbox "Enter frequency (Hz):" 10 50 "$frequency" 3>&1 1>&2 2>&3)
        volume=$(whiptail --title "Volume" --inputbox "Enter volume (0-100):" 10 50 "100" 3>&1 1>&2 2>&3)
        duration=$(whiptail --title "Duration" --inputbox "Enter duration (ms):" 10 50 "$default_duration" 3>&1 1>&2 2>&3)
        # Update Logic.tcl with the entered frequency, volume, and duration
        echo "beep"
        sed -i "s/playTone [0-9]\+ [0-9]\+ [0-9]\+/playTone $frequency $volume $duration/g" "$logicfile"
        ;;
    "Morse K")
        # Replace playTone with CW::play " K" or CW::play " T"
        sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play \" K\"/g' "$logicfile"

        ;;
    "Morse T")
        echo "T"
        # Replace playTone with CW::play " K" or CW::play " T"
        sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play \" T\"/g' "$logicfile"
        ;;
    "None")
        echo "None"
    # Replace playTone with CW::play ""
    sed -i 's/playTone [0-9]\+ [0-9]\+ [0-9]\+/CW::play \"\"/g' "$logicfile"
        ;;
esac