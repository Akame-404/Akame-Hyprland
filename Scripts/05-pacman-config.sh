#!/usr/bin/env bash
# Pacman tweaks

cat << "EOF"

┌──────────────────────┐
  Pacman Configuration   
└──────────────────────┘

EOF

if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf
    sudo pacman -Syyu
    sudo pacman -Fy
fi

echo -e "\n Pacman conf ✅"