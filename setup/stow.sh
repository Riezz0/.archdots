#!/usr/bin/env bash

#Remove Conflicting Files
rm -rf /home/$USER/.config/hypr
rm -rf /home/$USER/.config/kitty

# Navigate to the dotfiles directory
cd "$HOME/.archdots" || exit

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Gum is not installed. Please install it (e.g., sudo pacman -S gum)."
    exit 1
fi

# Header
gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1" --padding "1 2" \
    "󰄶 ARCH DOTFILES" "Automated Stow Sync"

# Get all directories, excluding hidden ones (like .git)
MODULES=$(find . -maxdepth 1 -type d -not -path '*/.*' -not -path '.' | sed 's|./||')

echo "Starting synchronization..."

# Loop through and stow everything
for folder in $MODULES; do
    # Using gum spin for each folder to look fancy
    gum spin --spinner dot --title " Linking $folder..." -- sleep 0.1
    
    # Stow -R (Restow) ensures fresh links even if they already exist
    if stow -R "$folder"; then
        echo "  $(gum style --foreground 82 "✔") $folder"
    else
        echo "  $(gum style --foreground 196 "✘") $folder (Error)"
    fi
done

# Success Footer
gum style --foreground 212 --margin "1" "✨ All configurations have been successfully linked!"
