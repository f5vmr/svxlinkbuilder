#!/bin/bash

function sa818_prog {
    # Paths to frequency files
    UHF_FILE="../Configs/UHF.txt"
    VHF_FILE="../Configs/VHF.txt"
    
    # Determine which frequency file to use based on $band
    if [ "$band" == "UHF" ]; then
        # Read UHF frequencies from file
        if [ -f "$UHF_FILE" ]; then
            mapfile -t frequencies < "$UHF_FILE"
        else
            whiptail --msgbox "Error: UHF frequency file not found!" 10 78
            exit 1
        fi
    elif [ "$band" == "VHF" ]; then
        # Read VHF frequencies from file
        if [ -f "$VHF_FILE" ]; then
            mapfile -t frequencies < "$VHF_FILE"
        else
            whiptail --msgbox "Error: VHF frequency file not found!" 10 78
            exit 1
        fi
    else
        whiptail --msgbox "Error: Invalid band selection!" 10 78
        exit 1
    fi

    # Create whiptail menu options from frequencies
    options=()
    for freq in "${frequencies[@]}"; do
        options+=("$freq" "")
    done

    # Frequency Selection
    selected_frequency=$(whiptail --title "$band Frequency Selection" --radiolist \
    "Select the $band frequency:" 20 78 12 "${options[@]}" 3>&1 1>&2 2>&3)

    # Output the results for verification
    echo "SA818 device fitted: $sa818"
    echo "Selected frequency band: $band"
    echo "Selected frequency: $selected_frequency"

    #### Changing Frequency ####
}
