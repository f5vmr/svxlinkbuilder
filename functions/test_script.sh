#!/bin/bash
# Debug SVXReflector JSON

# Set the language you want to test
lang="en_GB"   # <-- try your actual $lang value here

# Strip any .UTF-8 suffix if present
lang="${lang%%.*}"

# Function to map language to regions (simplified)
lang_to_regions() {
    local input="${1:-$lang}"
    local lang_code="${input%_*}"
    local country="${input#*_}"

    case "$lang_code" in
        en) echo "US GB IE ZA AU NZ CA-EN" ;;
        fr) echo "FR CA-FR CH" ;;
        it) echo "IT CH" ;;
        pt) echo "PT BR" ;;
        es) echo "ES MX AR" ;;
        us) echo "US CA MX" ;;
        *)  echo "$country" ;;
    esac
}

PRIMARY_REGION=$(lang_to_regions | awk '{print $1}')
ALL_REGIONS=$(lang_to_regions)

echo "DEBUG: lang='$lang'"
echo "DEBUG: PRIMARY_REGION='$PRIMARY_REGION'"
echo "DEBUG: ALL_REGIONS='$ALL_REGIONS'"

# GitHub JSON URL
REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/svxreflector_data/main/reflector_list.json"

# Fetch JSON
echo "Fetching JSON from GitHub..."
json=$(curl -fsSL "$REFLECTOR_LIST_URL") || {
    echo "Failed to fetch JSON"
    exit 1
}

echo "Preview of JSON (first 20 lines):"
echo "$json" | head -n20
echo "------------------------------"

# Extract all reflectors matching the language and primary region
echo "Filtering reflectors for language '$lang' and region '$PRIMARY_REGION'..."
list=$(jq -r --arg lang "$lang" --arg region "$PRIMARY_REGION" '
    .reflectors[]
    | select(.Language == $lang)
    | select(.countries[] == $region)
    | "\(.name)|\(.type)|\(.port)|\(.pwd)|\(.countries[])"' <<< "$json")

if [[ -z "$list" ]]; then
    echo "No matching reflectors found for this language/region."
else
    echo "Matching reflectors:"
    while IFS= read -r line; do
        IFS='|' read -r name type port pwd country <<< "$line"
        echo "Name: $name"
        echo "Type: $type"
        echo "Port: $port"
        echo "Password: $pwd"
        echo "Country: $country"
        echo "----------------------"
    done <<< "$list"
fi

# Optionally: print all reflectors for inspection
echo
echo "All reflectors in the file:"
jq -r '.reflectors[] | "\(.Language) | \(.name) | \(.type) | \(.port) | \(.pwd) | \(.countries[])"' <<< "$json"
echo "End of debug output."
