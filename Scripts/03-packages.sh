#!/usr/bin/env bash

cat << "EOF"

┌───────────────────────┐
  Packages Installation   
└───────────────────────┘

EOF


scrDir=$(dirname "$(realpath "$0")")

# Chemins vers les fichiers de liste
pacmanList="${scrDir}/pacman_pkg.lst"
aurList="${scrDir}/yay_pkg.lst"

archPkg=()
aurPkg=()

# Fonction de parsing d'une liste
parse_list() {
    local file="$1"
    local -n outputArray=$2

    while read -r line; do
        # Trim début
        line="${line#"${line%%[![:space:]]*}"}"
        # Ignore vide
        [ -z "$line" ] && continue
        # Ignore commentaire
        [[ "$line" == \#* ]] && continue
        # Récupère le mot avant #
        pkg="${line%%#*}"
        pkg="${pkg%"${pkg##*[![:space:]]}"}"
        [ -z "$pkg" ] && continue
        outputArray+=("$pkg")
    done < "$file"
}

# Parse la liste pacman
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

# Parse la liste AUR
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

# Installer paquets pacman
if [ ${#archPkg[@]} -gt 0 ]; then
    echo ">>> Installing pacman packages..."
    sudo pacman --noconfirm -S "${archPkg[@]}"
fi

# Installer paquets AUR
if [ ${#aurPkg[@]} -gt 0 ]; then
    if command -v yay &>/dev/null; then
        echo ">>> Installing AUR packages..."
        yay --noconfirm -S "${aurPkg[@]}"
    else
        echo "Error: yay not installed."
        exit 1
    fi
fi

echo -e "\nPackages installation✅"
