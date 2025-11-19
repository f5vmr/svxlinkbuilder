lang_to_regions() {
    # Use override if provided, otherwise fall back to global $lang
    local input="${1:-$lang}"
    local lang_code="${input%_*}"   # language part, xx
    local country="${input#*_}"     # country part, YY
    local regions

    # Map language codes to associated countries / radio prefixes
    case "$lang_code" in
        en)
            regions="US GB IE ZA AU NZ CA-EN"
            ;;
        fr)
            regions="FR CA-FR CH"
            ;;
        it)
            regions="IT CH"
            ;;
        pt)
            regions="PT BR"
            ;;
        es)
            regions="ES MX AR"
            ;;
        *)
            regions="$country"
            ;;
    esac

    # Ensure original country appears first if it is in the list
    if echo "$regions" | grep -qw "$country"; then
        regions="$country $(echo "$regions" | sed "s/\b$country\b//")"
    fi

    echo "$regions"
}
