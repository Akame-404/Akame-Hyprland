#!/usr/bin/env bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Hyprpaper configuration file
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# List all wallpapers sorted numerically by prefix
WALLPAPERS=($(ls -1v "$WALLPAPER_DIR"))

# Read the current wallpaper filename
CURRENT=$(grep '^wallpaper' "$CONFIG_FILE" | cut -d',' -f2 | xargs basename)

# Extract the numeric prefix of the current wallpaper
if [[ "$CURRENT" =~ ^([0-9]+)_ ]]; then
    CURRENT_NUM="${BASH_REMATCH[1]}"
else
    CURRENT_NUM=0
fi

# Compute the next numeric prefix
NEXT_NUM=$((CURRENT_NUM + 1))

# Find if a wallpaper with NEXT_NUM exists
NEXT_WALLPAPER=""
for wp in "${WALLPAPERS[@]}"; do
    if [[ "$wp" =~ ^(${NEXT_NUM})_ ]]; then
        NEXT_WALLPAPER="$wp"
        break
    fi
done

# If not found, fallback to 1
if [[ -z "$NEXT_WALLPAPER" ]]; then
    for wp in "${WALLPAPERS[@]}"; do
        if [[ "$wp" =~ ^1_ ]]; then
            NEXT_WALLPAPER="$wp"
            break
        fi
    done
fi

# If still not found, abort
if [[ -z "$NEXT_WALLPAPER" ]]; then
    echo "No wallpaper found with prefix 1_."
    exit 1
fi

# Absolute path
NEXT_PATH="$WALLPAPER_DIR/$NEXT_WALLPAPER"

echo "Switching to: $NEXT_PATH"

# Update hyprpaper.conf
{
    echo "preload = $NEXT_PATH"
    echo "wallpaper = , $NEXT_PATH"
} > "$CONFIG_FILE"

# Reload Hyprpaper
pkill -USR1 hyprpaper 2>/dev/null

# Send notification with Dunst
notify-send "Hyprpaper" "Wallpaper switched to: $NEXT_WALLPAPER"

echo "Wallpaper updated."
