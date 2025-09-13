#!/bin/bash

# terminal to use
TERMINAL="kitty"

# update commands
PACMAN_CMD="sudo pacman -Syu"
YAY_CMD="yay -Syu"

# launch the terminal
$TERMINAL sh -c "
echo '==========================================';
echo 'Available Updates:';
checkupdates || echo 'No Pacman updates available.';
yay -Qua || echo 'No AUR updates available.';
echo '==========================================';
read -p 'Continue with the upgrade? (y/N) ' choice;

if [[ \"\$choice\" == \"y\" || \"\$choice\" == \"Y\" ]]; then
    $PACMAN_CMD && $YAY_CMD;
else
    echo 'Upgrade canceled.';
fi;

read -p 'Press Enter to close...';
"
