#!/usr/bin/env bash

#PACKAGES#
PACKAGES=(adw-gtk-theme automake bats blueman bluez bluez-utils bottles cargo cmake cmatrix 
  code chromium dkms exa fastfetch feh firefox flatpak freedownloadmanager gnome-disk-utility 
  goverlay-git gum hypridle hyprlock hyprpicker kvantum-qt5 libreoffice-fresh liquidctl lutris
  make mesa-utils nautilus neovim net-tools nodejs-nativefier nwg-displays nwg-look openrgb 
  pulsemixer python-gobject python-hijri-converter python-pip python-psutil python-pytz python-pywal16 
  python-pywalfox python-requests python-virtualenv python-wxpython qdirstat qt5ct 
  qt5-graphicaleffects qt5-quickcontrols qt5-quickcontrols2 qt5-styleplugins qt6ct rofi-wayland rust scdoc 
  solaar steam stow swappy swaync swww tree ttf-font-awesome ttf-font-awesome-4 ttf-font-awesome-5 ttf-meslo-nerd 
  vencord vkbasalt vlc vlc-plugins-all waybar wf-recorder wl-clipboard xdg-desktop-portal-gtk xdg-desktop-portal-kde 
  xdg-desktop-portal-wlr xdg-desktop-portal-xapp xdg-terminal-exec xfce-polkit xfce4-settings zsh jq)

#GUM  
command -v gum >/dev/null 2>&1 && gum style --foreground 212 --border-foreground 212 --border double --align center --width 30 "Gum Dependency Already Installed" || sudo pacman -S gum --noconfirm

#AUR#
if ! command -v yay >/dev/null 2>&1; then
    gum confirm "Yay is not installed. Install yay (Git version)?" && {
        # We install dependencies normally so you can see the sudo password prompt
        sudo pacman -S --needed --noconfirm base-devel git go
        
        gum spin --spinner pulse --title "Cloning yay source..." -- \
            bash -c "BUILD_DIR=\$(mktemp -d) && git clone https://aur.archlinux.org/yay.git \$BUILD_DIR && echo \$BUILD_DIR > /tmp/yay_dir"
        
        YAY_DIR=$(cat /tmp/yay_dir)
        cd "$YAY_DIR" || exit
        
        # makepkg MUST run outside of gum to show the password and conflict prompts
        makepkg -si
        
        cd ~ && rm -rf "$YAY_DIR"
    } || exit 1
else
    gum style --foreground 212 --border double --align center --width 30 "Yay Already Installed"
fi
#UPDATES
UPDATES=$(yay -Qu 2>/dev/null)
if [ -n "$UPDATES" ]; then
    gum style --foreground 214 --border double --margin "1 1" --padding "0 2" "Updates Available"
    echo "$UPDATES" | gum format --type code
    echo ""
    gum style --foreground 196 --bold " WARNING: Updates Are Necessary For A Smooth System Experience And To Prevent Partial Upgrades."
    if gum confirm "Would You Like To Install These Updates Now?"; then
        yay -Syu
    else
        gum style --foreground 243 "Skipping Updates. Please Remember To Update Soon!"
    fi
else
    gum style --foreground 82 --border normal --padding "0 2" "All Packages Are Up To Date!"
fi

#INSTALL_PACKAGES
MISSING_PKGS=()

# Using "points" spinner (plural) as it is valid, unlike "dots"
gum spin --spinner points --title "Scanning local packages..." -- sleep 1

for pkg in "${PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
        MISSING_PKGS+=("$pkg")
    fi
done

# --- 4. Install Missing Packages ---
MISSING_PKGS=()

# --- 4. Robust Check for Installed Packages ---
gum spin --spinner points --title "Filtering already installed packages..." -- sleep 1

# Get a list of all installed packages once for speed
INSTALLED_LIST=$(pacman -Qq)

for pkg in "${PACKAGES[@]}"; do
    # Check if the exact package or a provider is installed
    if ! echo "$INSTALLED_LIST" | grep -qx "$pkg" >/dev/null 2>&1; then
        MISSING_PKGS+=("$pkg")
    fi
done

# --- 5. Install Missing Packages ---
if [ ${#MISSING_PKGS[@]} -eq 0 ]; then
    gum style --foreground 82 "✔ All requested packages are already satisfied."
else
    gum style --foreground 212 "Found ${#MISSING_PKGS[@]} packages to install."
    
    if gum confirm "Proceed with installation?"; then
        # We pass --needed one more time as a fail-safe
        # We also use --provides to help yay resolve virtual packages
        yay -S "${MISSING_PKGS[@]}" --needed --provides
        
        if [ $? -eq 0 ]; then
            gum style --foreground 82 --bold "✨ Environment setup complete!"
        else
            gum style --foreground 196 "✖ Installation was not completed (likely a conflict resolution choice)."
        fi
    fi
fi
