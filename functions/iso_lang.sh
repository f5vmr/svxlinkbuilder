#!/bin/sh
function iso_latin() {
    # Input: $1 = ISO country code (2 letters)
    # Returns: 0 = yes, 1 = no
    case "$1" in
        AL|AD|AT|BE|BA|BG|HR|CY|CZ|DK|EE|FI|FR|DE|HU|IS|IE|IT|LV|LI|LT|LU|MT|MC|ME|NL|NO|PL|PT|RO|SM|RS|SK|SI|ES|SE|CH|TR|GB|VA)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
export -f iso_latin
