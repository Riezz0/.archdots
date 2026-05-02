#!/bin/bash

# --- Setup ---
TEMP_DIR="/tmp/gradience_build"
mkdir -p "$TEMP_DIR"

# --- 1. Install Dependencies from Official Repos/AUR ---
# We use the AUR helper to get the majority of dependencies 
# This handles python-jinja, python-libsass, etc.
DEPS=(
    python-anyascii python-jinja python-libsass 
    python-material-color-utilities python-pluggy 
    python-regex python-svglib python-yapsy
)

gum style --foreground 212 "Installing standard dependencies..."
# Replace 'yay' with your preferred helper variable if integrating
yay -S --needed --noconfirm "${DEPS[@]}"

# --- 2. Install python-cssutils via Git ---
gum style --foreground 212 "Building python-cssutils from AUR..."
if ! pacman -Qi python-cssutils &> /dev/null; then
    cd "$TEMP_DIR"
    git clone https://aur.archlinux.org/python-cssutils.git
    cd python-cssutils
    gum spin --title "Building cssutils..." -- makepkg -sic --noconfirm
else
    gum style --foreground 10 "✔ python-cssutils already installed."
fi

# --- 3. Install Gradience-Git ---
gum style --foreground 212 "Building Gradience-Git..."
if ! pacman -Qi gradience-git &> /dev/null; then
    cd "$TEMP_DIR"
    git clone https://aur.archlinux.org/gradience-git.git
    cd gradience-git
    
    # Using gum to show a spinner during the build process
    gum spin --title "Compiling Gradience (this may take a moment)..." -- makepkg -sic --noconfirm
    
    gum style --foreground 10 --bold "✔ Gradience-git installed successfully!"
else
    gum style --foreground 214 "Gradience-git is already installed."
fi

# --- Cleanup ---
rm -rf "$TEMP_DIR"
