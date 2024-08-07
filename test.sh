#!/bin/bash

   #!/bin/bash

# UHF or VHF selection
frequency_band=$(whiptail --title "Frequency Band Selection" --menu "Choose the frequency band:" 10 78 2 \
"1" "UHF" \
"2" "VHF" 3>&1 1>&2 2>&3)

if [ "$frequency_band" -eq 1 ]; then
    # Generate UHF frequency list
    uhf_frequencies=()
    freq=433.400
    while (( $(echo "$freq <= 434.600" | bc -l) )); do
        uhf_frequencies+=("$freq")
        freq=$(echo "$freq + 0.0125" | bc)
    done
    
    # Create whiptail menu options from UHF frequencies
    options=()
    for freq in "${uhf_frequencies[@]}"; do
        options+=("$freq" "")
    done
    
    # UHF frequency selection
    selected_frequency=$(whiptail --title "UHF Frequency Selection" --radiolist \
    "Select the UHF frequency:" 20 78 12 "${options[@]}" 3>&1 1>&2 2>&3)
else
    # Generate VHF frequency list
    vhf_frequencies=()
    freq=145.200
    while (( $(echo "$freq <= 145.3375" | bc -l) )); do
        vhf_frequencies+=("$freq")
        freq=$(echo "$freq + 0.0125" | bc)
    done
    
    # Create whiptail menu options from VHF frequencies
    options=()
    for freq in "${vhf_frequencies[@]}"; do
        options+=("$freq" "")
    done
    
    # VHF frequency selection
    selected_frequency=$(whiptail --title "VHF Frequency Selection" --radiolist \
    "Select the VHF frequency:" 20 78 12 "${options[@]}" 3>&1 1>&2 2>&3)
fi

# Output the selected frequency for verification
echo "Selected frequency: $selected_frequency"

