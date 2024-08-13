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

    # Read frequencies into an array
    IFS=$'\n' read -d '' -r -a frequencies < "$FREQ_FILE"

    # Build the options array for whiptail
    options=()
    for freq in "${frequencies[@]}"; do
        # Add each frequency as an option with empty item text and default status "OFF"
        options+=("$freq" "" "OFF")
    done

    # Debugging: print the options to check them
    echo "Options passed to whiptail: ${options[@]}"

    # Display the whiptail radiolist
    selected_frequency=$(whiptail --title "$band Frequency Selection" --radiolist \
    "Select the $band frequency:" 20 100 10 "${options[@]}" 3>&1 1>&2 2>&3)

    # Output the selected frequency
    echo "Selected frequency: $selected_frequency"
}

