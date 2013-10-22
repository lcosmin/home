machine_tag() {
    _tagfile=~/.machine_tag

    if [[ -f "$_tagfile" ]]; then
        cat $_tagfile
    else
        echo "unknown"
    fi
}