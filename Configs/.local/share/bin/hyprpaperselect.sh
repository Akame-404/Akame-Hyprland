#!/usr/bin/env bash

wallpaper_dir="$HOME/.config/hypr/wallpapers"
roconf="$HOME/.config/rofi/styles/style.rasi"
rasi_file="$HOME/.config/rofi/styles/style.rasi"

# check if the rofi theme exists
if [ ! -f "$roconf" ]; then
    echo "error: rofi theme $roconf not found."
    exit 1
fi

# map file names to full paths
declare -A files_map
while IFS= read -r fullpath; do
    fname="$(basename "$fullpath")"
    files_map["$fname"]="$fullpath"
done < <(find "$wallpaper_dir" -type f)

# exit if no wallpapers are found
if [ ${#files_map[@]} -eq 0 ]; then
    echo "no wallpapers found in $wallpaper_dir"
    exit 1
fi

# rofi menu for wallpaper selection
wp_name=$(printf '%s\n' "${!files_map[@]}" | sort | rofi \
    -dmenu -p "select wallpaper" \
    -config "$roconf")

# exit if no wallpaper is selected
if [ -z "$wp_name" ]; then
    echo "no wallpaper selected."
    exit 0
fi

wp="${files_map[$wp_name]}"
echo "selected wallpaper: $wp"

# ensure hyprpaper is running (start it if needed)
if ! pgrep -x hyprpaper >/dev/null; then
    hyprpaper & disown
    # small delay so the ipc socket is ready
    sleep 0.3
fi

# set wallpaper using hyprpaper ipc (no need to edit hyprpaper.conf)
# empty monitor before the comma = apply to all monitors
hyprctl hyprpaper reload ",$wp"

# update rofi style background to match the new wallpaper
sed -i -E "s#background-image:.*#background-image:            url(\"$wp\", width);#g" "$rasi_file"

# send notification with the wallpaper name
notify-send "hyprpaper" "wallpaper set to $wp_name"
