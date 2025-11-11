#!/usr/bin/env bash
# Enable Bluetooth service

cat << "EOF"

┌───────────────────┐
  Enable Bluetooth  
└───────────────────┘

EOF

cat << "EOF"


echo ">>> Enabling Bluetooth service..."
sudo systemctl enable bluetooth.service || exit 1

echo -e "\n Bluetooth Enabled ✅"