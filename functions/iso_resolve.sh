#!/bin/sh
iso_resolver() {
    # Optional input LANG; defaults to global $LANG
    local input_lang="${1:-$LANG}"

    # Extract language code (first 2 letters)
    LANGUAGE_CODE=$(echo "$input_lang" | sed 's/^\([a-z][a-z]\).*/\1/')

    # Extract ISO country code (letters after _)
    COUNTRY_CODE=$(echo "$input_lang" | sed 's/.*_\(..\).*/\1/')

    # Default REGION = COUNTRY_CODE
    REGION="$COUNTRY_CODE"

    # Map special radio prefixes / dual-language countries
    case "$COUNTRY_CODE" in
        US) REGION="US" ;;        # USA
        GB) REGION="GB" ;;        # UK
        IE) REGION="EI" ;;        # Ireland
        GI) REGION="ZB" ;;        # Gibraltar
        ZA) REGION="ZA" ;;        # South Africa
        AU) REGION="VK" ;;        # Australia
        NZ) REGION="ZL" ;;        # New Zealand
        CA)                         # Canada: English/French
            if [ "$LANGUAGE_CODE" = "fr" ]; then
                REGION="CA-FR"
            else
                REGION="CA-EN"
            fi
            ;;
    esac

    # Check if this country is a European Latin ISO code
    if iso_latin "$COUNTRY_CODE"; then
        EURO_LATIN=1
    else
        EURO_LATIN=0
    fi

    # Export results for other functions
    export LANGUAGE_CODE COUNTRY_CODE REGION EURO_LATIN
}
export -f iso_resolver