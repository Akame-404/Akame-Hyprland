
#!/usr/bin/env bash

CONFIG="$HOME/.config/hypr/hyprland.conf"

# Récupérer la ligne actuelle
current=$(grep "^source = .*keybindings_" "$CONFIG")

if [[ "$current" == *"keybindings_us.conf" ]]; then
    # Passer en FR
    sed -i 's|source = .*/keybindings_us.conf|source = ~/.config/hypr/keybindings_fr.conf|' "$CONFIG"
    # Changer layout en FR
    sed -i 's|kb_layout = us.*|kb_layout = fr|' "$CONFIG"
    # Supprimer kb_variant s'il existe
    sed -i '/kb_variant/d' "$CONFIG"

    notify-send "Hyprland" "Clavier FR activé + keybindings FR"
else
    # Passer en US deadkeys
    sed -i 's|source = .*/keybindings_fr.conf|source = ~/.config/hypr/keybindings_us.conf|' "$CONFIG"
    # Changer layout en US
    sed -i 's|kb_layout = fr|kb_layout = us|' "$CONFIG"

    # Ajouter ou remplacer kb_variant
    if grep -q "kb_variant" "$CONFIG"; then
        sed -i 's|kb_variant = .*|kb_variant = intl|' "$CONFIG"
    else
        # Ajouter après kb_layout
        sed -i '/kb_layout = us/a\    kb_variant = intl' "$CONFIG"
    fi

    notify-send "Hyprland" "Clavier US (deadkeys) activé + keybindings US"
fi

# Recharger Hyprland
hyprctl reload

