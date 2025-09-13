#!/usr/bin/env bash
# Install and enable Ly Display Manager

cat << "EOF"

┌─────────────────────┐
  Ly DM Installation   
└─────────────────────┘

EOF

if pacman -Q ly &>/dev/null; then
    echo ">>> Ly is already installed."
else
    echo ">>> Installing Ly..."
    sudo pacman -S --noconfirm ly || exit 1
fi

if systemctl is-enabled ly.service &>/dev/null; then
    echo ">>> Ly service already enabled."
else
    echo ">>> Enabling Ly..."
    sudo systemctl enable ly.service || exit 1
fi

echo -e "\n Ly Installation ✅"