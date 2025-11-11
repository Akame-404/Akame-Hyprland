#!/usr/bin/env bash
#==========================================================
# install.sh - Master Installer
#==========================================================

sudo -v  # refresh sudo credentials

scrDir=$(dirname "$(realpath "$0")")
scriptsDir="${scrDir}/Scripts"

cat << "EOF"

┌─────────────────────────────┐
   Neo's Arch Setup Installer  
└─────────────────────────────┘

EOF

# Global check
if [ ! -d "${scriptsDir}" ]; then
    echo "Error: scripts directory not found."
    exit 1
fi

# Confirmation
echo ""
echo "⚠️  This will install and configure your system."
read -p "Do you want to proceed? [y/N] " choice
case "$choice" in
    y|Y|yes|YES) ;;
    *) echo "Aborting."; exit 1 ;;
esac

# Scripts to run in order
scripts=(
  00-update.sh
  01-ly.sh
  02-bluetooth.sh
  03-packages.sh
  04-grub.sh
  05-pacman-config.sh
  06-zsh.sh
  07-configs.sh
  08-wallpapers.sh
  09-services.sh
)

for script in "${scripts[@]}"; do
    if [ ! -f "${scriptsDir}/${script}" ]; then
        echo "Missing script: ${scriptsDir}/${script}"
        exit 1
    fi
    echo -e "\n>>> Running ${script}\n"
    bash "${scriptsDir}/${script}"
done

cat << "EOF"

┌────────────────────────────────────────┐
   Akame Hyprland installation Complete  
└────────────────────────────────────────┘

EOF

echo -e "\n✅ All steps completed successfully!"
echo "Select 'Hyprland' from Ly at the next login."

# Reboot prompt
read -p "Would you like to reboot now? [Y/n] " ans
case "$ans" in
  [nN]*) echo "Reboot skipped. Please restart manually before using Hyprland."; ;;
  *) echo "🚀 Rebooting..."; sleep 2; sudo reboot ;;
esac
