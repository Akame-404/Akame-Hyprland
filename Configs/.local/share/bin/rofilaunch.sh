#!/usr/bin/env sh

# Set variables
scrDir="$(dirname "$(realpath "$0")")"

# Path to the fixed theme
roconf="$HOME/.config/rofi/styles/style.rasi"

# Check that the theme exists
if [ ! -f "$roconf" ]; then
    echo "Error: Rofi theme $roconf not found."
    exit 1
fi

# Rofi action
case "${1}" in
    d|--drun) r_mode="drun" ;; 
    w|--window) r_mode="window" ;;
    f|--filebrowser) r_mode="filebrowser" ;;
    h|--help) 
        echo -e "$(basename "${0}") [action]"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode"
        exit 0 ;;
    *) r_mode="drun" ;;
esac

# Launch rofi with NO overrides
rofi -show "${r_mode}" -config "${roconf}"
