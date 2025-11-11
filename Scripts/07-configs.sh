#!/usr/bin/env bash
# Copy dotfiles and configs

cat << "EOF"

┌────────────────────┐
  Files Installation   
└────────────────────┘

EOF

scrDir=$(dirname "$(realpath "$0")")/../Configs

if [ -d "${scrDir}/.config" ]; then
    mkdir -p ~/.config
    cp -rf "${scrDir}/.config/"* ~/.config/
fi

if [ -d "${scrDir}/.local" ]; then
    mkdir -p ~/.local
    cp -rf "${scrDir}/.local/"* ~/.local/
fi

if [ -d "${scrDir}/.icons" ]; then
    mkdir -p ~/.icons
    cp -rf "${scrDir}/.icons/"* ~/.icons/
fi

for file in .zshrc .p10k.zsh; do
    [ -f "${scrDir}/${file}" ] && cp -f "${scrDir}/${file}" ~/
done
echo -e "\n Configs files ✅"