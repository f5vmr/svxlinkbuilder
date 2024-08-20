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
#    echo "Options passed to whiptail: ${options[@]}"
###     sa818 --help
### usage: sa818 [-h] [--debug] [--port PORT] [--speed {300,1200,2400,4800,9600,19200,38400,57600,115200}]
###              {radio,volume,filters,filter,version} ...
### 
### generate configuration for switch port
### 
### positional arguments:
###   {radio,volume,filters,filter,version}
###     radio               Program the radio (frequency/tone/squelch)
###     volume              Set the volume level
###     filters (filter)    Enable/Disable filters
###     version             Show the firmware version of the SA818
### 
### options:
###   -h, --help            show this help message and exit
###   --debug
###   --port PORT           Serial port [default: linux console port]
###   --speed {300,1200,2400,4800,9600,19200,38400,57600,115200}
###                         Connection speed
### 
### You can specify a different code for transmit and receive by separating them by a comma.
### > Example: --ctcss 94.8,127.3 or --dcs 043N,047N
### 
### CTCSS codes (PL Tones)
### 67.0, 71.9, 74.4, 77.0, 79.7, 82.5, 85.4, 88.5, 91.5, 94.8, 97.4,
### 100.0, 103.5, 107.2, 110.9, 114.8, 118.8, 123.0, 127.3, 131.8, 136.5,
### 141.3, 146.2, 151.4, 156.7, 162.2, 167.9, 173.8, 179.9, 186.2, 192.8,
### 203.5, 210.7, 218.1, 225.7, 233.6, 241.8, 250.3
### 
### DCS Codes:
### DCS codes must be followed by N or I for Normal or Inverse:
### > Example: 047I
### 023, 025, 026, 031, 032, 036, 043, 047, 051, 053, 054, 065, 071, 072,
### 073, 074, 114, 115, 116, 125, 131, 132, 134, 143, 152, 155, 156, 162,
### 165, 172, 174, 205, 223, 226, 243, 244, 245, 251, 261, 263, 265, 271,
### 306, 311, 315, 331, 343, 346, 351, 364, 365, 371, 411, 412, 413, 423,
### 431, 432, 445, 464, 465, 466, 503, 506, 516, 532, 546, 565, 606, 612,
### 624, 627, 631, 632, 654, 662, 664, 703, 712, 723, 731, 732, 734, 743,
### 754
### 

    # Display the whiptail radiolist
    selected_frequency=$(whiptail --title "$band Frequency Selection" --radiolist \
    "Select the $band frequency:" 20 100 15 "${options[@]}" 3>&1 1>&2 2>&3)

    # Output the selected frequency
    echo "Selected frequency: $selected_frequency"
    # ask for bandwidth
    band_width=$(whiptail --title "SA818 Band Width" --radiolist \
"Do you want Narrow-band (12.5 KHz) or Wide-band (25 KHz)?" 10 78 2 \
"NB" "Narrow-band" ON \
"WB" "Wide-band" OFF 3>&1 1>&2 2>&3)
    # Filters
    # Volume
    # Squelch
    # CTCSS Tone
}

