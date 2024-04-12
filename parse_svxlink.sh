#!/bin/bash

input_file="/etc/svx/svxlink.conf"
output_file="/etc/svxlink/svxlink.db"

header_written=false
header_lines=0

while IFS= read -r line; do
    line=$(echo "$line" | tr -d '\r\n') ## Remove carriage return and newline characters
    if [ $header_lines -lt 5 ] 
    then
        ## Write the first five lines as header without parsing them
        echo "$line" | tee -a   "$output_file"
        ((header_lines++))
    elif [[ "$line" == "\"[*]* ]] 
    then
        category=${line:1:-1}
        ## Write header category without parameters if not already written
        if [ "$category" == "Header" ] && [ "$header_written" = false ] 
        then
            echo "$category" | tee -a   "$output_file"
            header_written=true
        fi
    elif [[ "$line" == "\" ]] 
    then
        ## Parameter heading
        parameter_heading=$(echo "$line" | cut -d '=' -f 1 | sed 's/# *//')
        parameter=$(echo "$line" | cut -d '=' -f 2-)
        echo "$category,$parameter_heading,$parameter" | tee -a   "$output_file"
    elif [[ -n "$line" ]] 
    then
        ## Regular parameter
        parameter_heading=$(echo "$line" | cut -d '=' -f 1)
        parameter=$(echo "$line" | cut -d '=' -f 2-)
        echo "$category,$parameter_heading,$parameter" | tee -a   "$output_file"
    fi
done < "$input_file"
