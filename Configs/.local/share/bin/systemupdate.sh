#!/usr/bin/env bash

# Check release
if [ ! -f /etc/arch-release ]; then
    exit 0
fi

# Define script directory
scrDir=$(dirname "$(realpath "$0")")

# Function to check if a package is installed
pkg_installed() {
    local pkgIn="$1"
    if pacman -Qi "$pkgIn" &>/dev/null; then
        return 0
    elif pacman -Qi "flatpak" &>/dev/null && flatpak info "$pkgIn" &>/dev/null; then
        return 0
    elif command -v "$pkgIn" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Determine AUR helper
if pkg_installed yay; then
    aurhlpr="yay"
elif pkg_installed paru; then
    aurhlpr="paru"
else
    aurhlpr=""
fi

# Command to update flatpak packages if flatpak is installed
if pkg_installed flatpak; then
    fpk_exup="flatpak update"
else
    fpk_exup=""
fi

# Trigger upgrade
if [ "$1" == "up" ]; then
    trap 'pkill -RTMIN+20 waybar' EXIT
    command="
fastfetch
$0 upgrade
${aurhlpr} -Syu
${fpk_exup}
read -n 1 -p 'Press any key to continue...'
"
    kitty --title systemupdate sh -c "${command}"
    exit
fi

# Check for AUR updates
aur=0
if [ -n "$aurhlpr" ]; then
    aur=$($aurhlpr -Qua | wc -l)
fi

# Check for official repo updates
ofc=$( (while pgrep -x checkupdates >/dev/null; do sleep 1; done) ; checkupdates | wc -l)

# Check for flatpak updates
if pkg_installed flatpak; then
    fpk=$(flatpak remote-ls --updates | wc -l)
    fpk_disp="\n󰏓 Flatpak $fpk"
else
    fpk=0
    fpk_disp=""
fi

# Calculate total available updates
upd=$((ofc + aur + fpk))

# Show detailed upgrade counts
if [ "$1" == "upgrade" ]; then
    printf "[Official] %-10s\n[AUR]      %-10s\n[Flatpak]  %-10s\n" "$ofc" "$aur" "$fpk"
    exit
fi

# Show tooltip JSON
if [ "$upd" -eq 0 ]; then
    upd="" # Remove icon completely if no updates
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi
