#!/bin/bash

# Function to generate frequency list
generate_frequencies() {
    local start_freq=$1
    local end_freq=$2
    local increment=$3
    local -n freq_array=$4
    local freq=$start_freq

    while (( $(echo "$freq <= $end_freq" | bc -l) )); do
        freq_array+=("$freq" "")
        freq=$(echo "$freq + $increment" | bc)
    done
}

# UHF or VHF selection
frequency_band=$(whiptail --title "Frequency Band Selection" --menu "Choose the frequency band:" 10 78 2 \
"1" "UHF" \
"2" "VHF" 3>&1 1>&2 2>&3)

if [ "$frequency_band" -eq 1 ]; then
    # Generate UHF frequency list
    uhf_frequencies=()
    generate_frequencies 433.400 434.600 0.0125 uhf_frequencies

    # Prepare UHF frequencies for whiptail
    options=()
    for freq in "${uhf_frequencies[@]}"; do
        options+=("$freq" "")
    done

    # Debug: Print UHF options to verify
    echo "UHF Frequencies: ${options[@]}"

    # UHF frequency selection
    selected_frequency=$(whiptail --title "UHF Frequency Selection" --radiolist \
    "Select the UHF frequency:" 20 78 12 "${options[@]}" 3>&1 1>&2 2>&3)
elif [ "$frequency_band" -eq 2 ]; then
    # Generate VHF frequency list
    vhf_frequencies=()
    generate_frequencies 145.200 145.3375 0.0125 vhf_frequencies

    # Prepare VHF frequencies for whiptail
    options=()
    for freq in "${vhf_frequencies[@]}"; do
        options+=("$freq" "")
    done

    # Debug: Print VHF options to verify
    echo "VHF Frequencies: ${options[@]}"

    # VHF frequency selection
    selected_frequency=$(whiptail --title "VHF Frequency Selection" --radiolist \
    "Select the VHF frequency:" 20 78 12 "${options[@]}" 3>&1 1>&2 2>&3)
else
    selected_frequency="Invalid selection or no SA818 device"
fi

# Output the selected frequency for verification
echo "Selected frequency: $selected_frequency"
