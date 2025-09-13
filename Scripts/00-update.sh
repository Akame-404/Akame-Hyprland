#!/usr/bin/env bash
# System + AUR updates

cat << "EOF"

┌────────────────────┐
  Starting upgrade   
└────────────────────┘

EOF

echo ">>> Updating system..."
sudo pacman -Syu --noconfirm || {
    echo "Error: Pacman update failed."
    exit 1
}

if command -v yay &>/dev/null; then
    echo ">>> Updating AUR packages..."
    yay -Syu --noconfirm || {
        echo "Error: Yay update failed."
        exit 1
    }
fi

echo -e "\n Packages Up to Date ✅"