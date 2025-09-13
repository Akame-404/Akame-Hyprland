#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
roconf="$HOME/.config/rofi/styles/style.rasi"
rasi_file="$HOME/.config/rofi/styles/style.rasi"

if [ ! -f "$roconf" ]; then
    echo "Error: Rofi theme $roconf not found."
    exit 1
fi

declare -A files_map
while IFS= read -r fullpath; do
    fname="$(basename "$fullpath")"
    files_map["$fname"]="$fullpath"
done < <(find "$WALLPAPER_DIR" -type f)

if [ ${#files_map[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

WP_NAME=$(printf '%s\n' "${!files_map[@]}" | sort | rofi \
    -dmenu -p "Select wallpaper" \
    -config "$roconf")

if [ -z "$WP_NAME" ]; then
    echo "No wallpaper selected."
    exit 0
fi

WP="${files_map[$WP_NAME]}"
echo "Selected wallpaper: $WP"

{
    echo "preload = $WP"
    echo "wallpaper = , $WP"
} > "$CONFIG_FILE"

pkill -USR1 hyprpaper 2>/dev/null
hyprpaper

current_wallpaper=$(grep '^wallpaper' "$CONFIG_FILE" | sed 's/.*,//' | xargs)

if [ -z "$current_wallpaper" ]; then
  echo "Erreur: Aucun wallpaper trouvé dans hyprpaper.conf"
  exit 1
fi

sed -i -E "s#background-image:.*#background-image:            url(\"$current_wallpaper\", width);#g" "$rasi_file"

notify-send "Hyprpaper" "Wallpaper set to: $WP_NAME"
