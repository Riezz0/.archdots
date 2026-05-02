#!/bin/bash

# 1. Define the EXACT path (Case-Sensitive)
SETTINGS_DIR="$HOME/.config/Code - OSS/User"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

# 2. Ensure the directory exists
mkdir -p "$SETTINGS_DIR"

# 3. Install the extension 
# Note: In most OSS builds, the command is 'code-oss'
if command -v code-oss &> /dev/null; then
    echo "Installing Wal extension for Code-OSS..."
    code-oss --install-extension dlasagno.wal-theme --force
else
    # Fallback to 'code' if your alias is different
    code --install-extension dlasagno.wal-theme --force
fi

# 4. Write the configuration
# Using 'python3' to handle the JSON properly if you have existing settings,
# or just 'cat' if you want to overwrite everything:
cat <<EOF > "$SETTINGS_FILE"
{
    "workbench.colorTheme": "Wal",
    "wal.path": "$HOME/.cache/wal/colors.json"
}
EOF

# 5. Generate/Sync colors
wal -R

echo "Done! The theme is now set to 'Wal' in $SETTINGS_FILE."
