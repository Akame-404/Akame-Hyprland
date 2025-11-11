#!/usr/bin/env bash
# Copy wallpapers

cat << "EOF"

┌─────────────────────────┐
  Wallpapers Installation   
└─────────────────────────┘

EOF

scrDir=$(dirname "$(realpath "$0")")/..

if [ -d "${scrDir}/Source/Wallpapers" ]; then
    mkdir -p ~/.config/hypr/wallpapers
    cp -rf "${scrDir}/Source/Wallpapers/"* ~/.config/hypr/wallpapers/
fi
