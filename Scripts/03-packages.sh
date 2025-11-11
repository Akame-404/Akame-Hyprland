#!/usr/bin/env bash

cat << "EOF"

┌───────────────────────┐
  Packages Installation   
└───────────────────────┘

EOF


scrDir=$(dirname "$(realpath "$0")")

# Paths to package list files
pacmanList="${scrDir}/pacman_pkg.lst"
aurList="${scrDir}/yay_pkg.lst"

archPkg=()
aurPkg=()

# Function to parse a package list file
parse_list() {
    local file="$1"
    local -n outputArray=$2

    while IFS= read -r line || [ -n "$line" ]; do
        # Remove carriage returns (\r) in case of Windows-style line endings
        line="${line//$'\r'/}"

        # Trim leading whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        # Trim trailing whitespace
        line="${line%"${line##*[![:space:]]}"}"

        # Skip empty lines
        [ -z "$line" ] && continue
        # Skip lines starting with #
        [[ "$line" == \#* ]] && continue

        # --- NEW: Cut everything after # (inline comments) ---
        pkg="${line%%#*}"
        # Re-trim trailing spaces after cutting
        pkg="${pkg%"${pkg##*[![:space:]]}"}"

        # Ignore if nothing remains after trimming
        [ -z "$pkg" ] && continue

        outputArray+=("$pkg")
    done < "$file"
}   # <-- function closed here

# Parse pacman package list
if [ -f "$pacmanList" ]; then
    echo ">>> Parsing pacman list..."
    pacmanPkgs=()
    parse_list "$pacmanList" pacmanPkgs

    for pkg in "${pacmanPkgs[@]}"; do
        if pacman -Q "$pkg" &>/dev/null; then
            echo -e "\033[0;33m[skip]\033[0m $pkg already installed."
        else
            echo -e "\033[0;32m[repo]\033[0m queueing $pkg"
            archPkg+=("$pkg")
        fi
    done
else
    echo "Warning: pacman_pkg.lst not found."
fi

# Parse AUR package list
if [ -f "$aurList" ]; then
    echo ">>> Parsing AUR list..."
    aurPkgs=()
    parse_list "$aurList" aurPkgs

    for pkg in "${aurPkgs[@]}"; do
        if pacman -Q "$pkg" &>/dev/null; then
            echo -e "\033[0;33m[skip]\033[0m $pkg already installed."
        else
            echo -e "\033[0;34m[aur]\033[0m queueing $pkg"
            aurPkg+=("$pkg")
        fi
    done
else
    echo "Warning: yay_pkg.lst not found."
fi

# Pre-installation checks
if ! command -v pacman &>/dev/null; then
    echo "Error: pacman not found."
    exit 1
fi

# Install pacman packages
if [ ${#archPkg[@]} -gt 0 ]; then
    echo ">>> Installing pacman packages..."
    # Cache sudo password
    sudo -v || true
    sudo pacman --noconfirm --needed -S "${archPkg[@]}"
fi

# Install AUR packages
if [ ${#aurPkg[@]} -gt 0 ]; then
    if command -v yay &>/dev/null; then
        echo ">>> Installing AUR packages..."
        yay --noconfirm --needed -S "${aurPkg[@]}"
    else
        echo "Error: yay not installed."
        exit 1
    fi
fi

echo -e "\nPackages installation ✅"
