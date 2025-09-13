#!/usr/bin/env bash
#==========================================================
# install.sh - Master Installer
#==========================================================

scrDir=$(dirname "$(realpath "$0")")
scriptsDir="${scrDir}/Scripts"

cat << "EOF"

┌─────────────────────────────┐
   Neo's Arch Setup Installer  
└─────────────────────────────┘

EOF

# Vérification globale
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

# Lancement des scripts dans l'ordre
for script in \
    00-update.sh \
    01-ly.sh \
    02-bluetooth.sh \
    03-packages.sh \
    04-grub.sh \
    05-pacman-config.sh \
    06-zsh.sh \
    07-configs.sh \
    08-wallpapers.sh \
    09-service.sh
do
    echo -e "\n>>> Running ${script}\n"
    bash "${scriptsDir}/${script}"
done

echo -e "\n✅ All steps completed successfully!"
