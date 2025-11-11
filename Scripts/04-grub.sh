#!/usr/bin/env bash
# Install and configure GRUB themes

cat << "EOF"

┌───────────────────┐
  Grub Installation   
└───────────────────┘

EOF


scrDir=$(dirname "$(realpath "$0")")/..
grub_dir="${scrDir}/Source/Grub"

# Install GRUB if not present
sudo pacman -S --noconfirm grub os-prober efibootmgr || exit 1

# Menu interactif complet
echo -e "Select GRUB theme:\n\
[1] Cat\n\
[2] Cyberpunk\n\
[3] Darlinx\n\
[4] Spaceship\n\
[5] Witch\n\
[Enter] Skip theme installation"

read -p "Enter option number: " opt

case $opt in
    1) theme="Cat" ;;
    2) theme="Cyberpunk" ;;
    3) theme="Darlinx" ;;
    4) theme="Spaceship" ;;
    5) theme="Witch" ;;
    *) theme="None" ;;
esac

if [ "$theme" != "None" ]; then
    echo ">>> Installing GRUB theme: $theme"
    # Extraire le thème
    sudo tar -xzf "${grub_dir}/${theme}.tar.gz" -C /usr/share/grub/themes/
    # Configurer le thème
    sudo sed -i "/^GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${theme}/theme.txt\"" /etc/default/grub
    sudo sed -i "/^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${theme}/theme.txt\"" /etc/default/grub
else
    echo ">>> Skipping GRUB theme installation."
    # Désactiver GRUB_THEME si existant
    sudo sed -i "s/^GRUB_THEME=/#GRUB_THEME=/" /etc/default/grub
fi

# Regénérer le fichier grub.cfg
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\n Grub conf ✅"