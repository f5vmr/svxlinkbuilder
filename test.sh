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

    # Debug: Print UHF options to verify
    echo "UHF Frequencies:"
    for i in "${!uhf_frequencies[@]}"; do
        if (( i % 2 == 0 )); then
            echo "Frequency: ${uhf_frequencies[i]}"
        fi
    done

    # UHF frequency selection
    selected_frequency=$(whiptail --title "UHF Frequency Selection" --radiolist \
    "Select the UHF frequency:" 20 78 12 "${uhf_frequencies[@]}" 3>&1 1>&2 2>&3)
elif [ "$frequency_band" -eq 2 ]; then
    # Generate VHF frequency list
    vhf_frequencies=()
    generate_frequencies 145.200 145.3375 0.0125 vhf_frequencies

    # Debug: Print VHF options to verify
    echo "VHF Frequencies:"
    for i in "${!vhf_frequencies[@]}"; do
        if (( i % 2 == 0 )); then
            echo "Frequency: ${vhf_frequencies[i]}"
        fi
    done

    # VHF frequency selection
    selected_frequency=$(whiptail --title "VHF Frequency Selection" --radiolist \
    "Select the VHF frequency:" 20 78 12 "${vhf_frequencies[@]}" 3>&1 1>&2 2>&3)
else
    selected_frequency="Invalid selection or no SA818 device"
fi

# Output the selected frequency for verification
echo "Selected frequency: $selected_frequency"
