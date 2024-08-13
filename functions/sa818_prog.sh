#!/bin/bash

function sa818_prog {
    # Define full file paths
    UHF_FILE="/home/pi/svxlinkbuilder/configs/UHF.txt"
    VHF_FILE="/home/pi/svxlinkbuilder/configs/VHF.txt"

    # Select file based on band
    if [ "$band" == "UHF" ]; then
        FREQ_FILE="$UHF_FILE"
    else
        FREQ_FILE="$VHF_FILE"
    fi

    # Check if the frequency file exists
    if [ ! -f "$FREQ_FILE" ]; then
        echo "Error: Frequency file not found at $FREQ_FILE"
        exit 1
    fi

    # Read frequencies from the CSV file
    frequencies=$(tr -d '\r' < "$FREQ_FILE" | tr ',' '\n')

    # Build the options array for whiptail
    options=()
    while IFS= read -r freq; do
        # Ensure the frequency is properly trimmed of any extra spaces or newlines
        freq=$(echo "$freq" | xargs)
        # Add each frequency as an option with empty item text and default status "OFF"
        options+=("$freq" "" "OFF")
    done <<< "$frequencies"

    # Debugging: print the options to check them
    echo "Options passed to whiptail: ${options[@]}"

    # Display the whiptail radiolist
    selected_frequency=$(whiptail --title "$band Frequency Selection" --radiolist \
    "Select the $band frequency:" 20 100 10 "${options[@]}" 3>&1 1>&2 2>&3)

    # Output the selected frequency
    echo "Selected frequency: $selected_frequency"
}

