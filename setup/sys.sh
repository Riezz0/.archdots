#!/usr/bin/env bash

# --- Helper Functions ---
step_msg() {
    gum style --foreground 212 "󰄶 $1"
}

success_msg() {
    echo "  $(gum style --foreground 82 "✔") $1"
}

# --- Header ---
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 60 --margin "1" --padding "1 2" \
    "SYSTEM DEPLOYMENT" "Tokyo Night Theme Engine"

# --- 1. Cleanup ---
step_msg "Cleaning conflicting files..."
sudo rm -f /etc/sddm.conf /etc/default/grub
success_msg "Conflicts cleared"

# --- 2. Fonts ---
step_msg "Installing system fonts..."
mkdir -p ~/.local/share/fonts
gum spin --spinner dots --title " Copying fonts & rebuilding cache..." -- \
    bash -c "cp -r $HOME/.archdots/fonts/* $HOME/.local/share/fonts && fc-cache -f"
success_msg "Fonts updated"

# --- 3. Drivers ---
step_msg "Compiling NCT6687D driver..."
gum spin --spinner pulse --title " Cloning & installing via DKMS..." -- \
    bash -c "git clone https://github.com/Fred78290/nct6687d $HOME/tmp/nct6687d && \
    cd $HOME/tmp/nct6687d/ && make dkms/install"

sudo cp -r "$HOME/.archdots/sys/no_nct6683.conf" /etc/modprobe.d/
sudo cp -r "$HOME/.archdots/sys/nct6687.conf" /etc/modules-load.d/nct6687.conf
sudo modprobe nct6687
success_msg "Driver active"

# --- 4. Cursors ---
step_msg "Applying system cursors..."
sudo rm -rf /usr/share/icons/default
sudo cp -r "$HOME/.archdots/sys/cursors/default" /usr/share/icons/
sudo cp -r "$HOME/.archdots/sys/cursors/oreo_white_cursors" /usr/share/icons/
success_msg "Cursors set to Oreo White"

# --- 5. Theme & GTK ---
step_msg "Injecting Tokyo Night aesthetics..."
cp "$HOME/.archdots/hypr-themes/.config/.hypr-themes/tokyo-night/thumbnail.png" "$HOME/.config/hypr/Wall.png"
bash "$HOME/.archdots/hypr-themes/.config/.hypr-themes/tokyo-night/tokyo-night.sh"

gum spin --spinner segments --title " Configuring GSettings..." -- \
    bash -c 'gsettings set org.gnome.desktop.interface font-name "MesloLGL Nerd Font 12" && \
    gsettings set org.gnome.desktop.interface document-font-name "MesloLGL Nerd Font 12" && \
    gsettings set org.gnome.desktop.interface monospace-font-name "MesloLGL Mono Nerd Font 12" && \
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "MesloLGL Mono Nerd Font 12"'
success_msg "Theme applied"

# --- 6. Services & System ---
step_msg "Finalizing System Settings..."
# SDDM
sudo cp -r "$HOME/.archdots/sys/sddm/sddm.conf" /etc/
sudo cp -r "$HOME/.archdots/sys/sddm/tokyo-night/" /usr/share/sddm/themes/
# Cooler Control
sudo systemctl enable --now coolercontrold.service
# GRUB
sudo cp -r "$HOME/.archdots/sys/grub/grub" /etc/default/
sudo cp -r "$HOME/.archdots/sys/grub/tokyo-night" /usr/share/grub/themes/
gum spin --spinner box --title " Regenerating GRUB config..." -- sudo grub-mkconfig -o /boot/grub/grub.cfg

# --- Completion ---
dunstify -u critical "Installation Complete" "Please reboot to apply all changes"

gum style --foreground 82 --border-foreground 82 --border rounded --align center --width 60 --margin "1" \
    "STATION READY" "Everything installed successfully."

# --- Reboot ---
if gum confirm "Deployment finished. Reboot now?"; then
    gum style --foreground 212 "Rebooting in 3 seconds..."
    sleep 3
    sudo systemctl reboot
else
    gum style --foreground 196 "Reboot cancelled. Please restart manually."
fi
