#!/bin/bash

#Calling the functions.
#source "${BASH_SOURCE%/*}/functions/sa818_test.sh"
#sa818_test
#source "${BASH_SOURCE%/*}/functions/sa818_prog.sh"
#sa818_prog
#
#echo "$band SA818 device fitted and programmed to $selected_frequency "


# Define the starting frequency, ending frequency, and step size
start_freq=433.0125
end_freq=434.7500
step=0.0125

# Define the output file path
output_file="/home/pi/svxlinkbuilder/configs/UHF.txt"

# Initialize an empty string for storing the frequencies
frequencies=""

# Loop to generate frequencies and append them to the string
current_freq=$start_freq
while (( $(echo "$current_freq <= $end_freq" | bc -l) )); do
    frequencies+=$(printf "%.4f" $current_freq)","
    current_freq=$(echo "$current_freq + $step" | bc)
done

# Remove the trailing comma and save to the file
frequencies=${frequencies%,}
echo $frequencies > $output_file

echo "Frequencies saved to $output_file"
