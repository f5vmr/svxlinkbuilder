#!/bin/bash

# Define the start and end frequencies and the interval
START_FREQ=433.0125
END_FREQ=434.7500
INTERVAL=0.125

# Output file
OUTPUT_FILE="/home/pi/svxlinkbuilder/UHF.txt"

# Initialize the current frequency
current_freq=$START_FREQ

# Create or clear the output file
: > "$OUTPUT_FILE"

# Generate frequencies
while (( $(echo "$current_freq <= $END_FREQ" | bc -l) )); do
    # Write the current frequency to the file, with a comma separator
    printf "%.4f," "$current_freq" >> "$OUTPUT_FILE"
    # Increment the frequency
    current_freq=$(echo "$current_freq + $INTERVAL" | bc)
done

# Remove the trailing comma
sed -i '$ s/,$//' "$OUTPUT_FILE"

# Notify the user
echo "Frequencies saved to $OUTPUT_FILE"
