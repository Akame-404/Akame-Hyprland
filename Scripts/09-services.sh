#!/usr/bin/env bash

set -euo pipefail

cat << "EOF"

┌───────────────────────┐
     Services Setup       
└───────────────────────┘

EOF

# --- User services ---
echo ">>> Enabling gnome-keyring..."
systemctl --user enable --now gnome-keyring-daemon.socket

# --- System services ---
echo ">>> Enabling docker..."
sudo systemctl enable --now docker

echo ">>> Enabling snapd..."
sudo systemctl enable --now snapd
sudo systemctl enable --now snapd.socket

echo -e "\nServices setup ✅"

