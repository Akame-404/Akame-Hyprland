#!/usr/bin/env sh

#// INIT CONFIG ENVIRONNEMENT (extrait de globalcontrol.sh)

# chemins principaux
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"


# fallback enableWallDcol si vide
case "${enableWallDcol}" in
    0|1|2|3) ;;
    *) enableWallDcol=0 ;;
esac


#// INIT HYPRLAND VARIABLES

if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null; then
    hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
    hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"
fi

#// SCRIPT PRINCIPAL

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null
then
    pkill -x "wlogout"
    exit 0
fi

# set file variables
scrDir=$(dirname "$(realpath "$0")")
[ -z "${1}" ] || wlogoutStyle="${1}"
wLayout="${confDir}/wlogout/layout_${wlogoutStyle}"
wlTmplt="${confDir}/wlogout/style_${wlogoutStyle}.css"

if [ ! -f "${wLayout}" ] || [ ! -f "${wlTmplt}" ] ; then
    wlogoutStyle=1
    wLayout="${confDir}/wlogout/layout_${wlogoutStyle}"
    wlTmplt="${confDir}/wlogout/style_${wlogoutStyle}.css"
fi

# detect monitor res
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# scale config layout and style
case "${wlogoutStyle}" in
    1)  wlColms=6
        export mgn=$(( y_mon * 28 / hypr_scale ))
        export hvr=$(( y_mon * 23 / hypr_scale )) ;;
    2)  wlColms=2
        export x_mgn=$(( x_mon * 35 / hypr_scale ))
        export y_mgn=$(( y_mon * 25 / hypr_scale ))
        export x_hvr=$(( x_mon * 32 / hypr_scale ))
        export y_hvr=$(( y_mon * 20 / hypr_scale )) ;;
esac

# scale font size
export fntSize=$(( y_mon * 2 / 100 ))

# detect wallpaper brightness
[ -f "${cacheDir}/wall.dcol" ] && source "${cacheDir}/wall.dcol"

if [ "${enableWallDcol}" -eq 0 ]; then
    grep -q "dark" <<< "${colorScheme}" && dcol_mode="dark"
    grep -q "light" <<< "${colorScheme}" && dcol_mode="light"
fi


[ "${dcol_mode}" = "dark" ] && export BtnCol="white" || export BtnCol="white"

# eval hypr border radius
export active_rad=$(( hypr_border * 5 ))
export button_rad=$(( hypr_border * 8 ))

# eval config files
wlStyle="$(envsubst < "$wlTmplt")"

# launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
