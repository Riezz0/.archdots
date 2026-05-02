#!/bin/bash

# 1. Switch to the next layout
hyprctl switchxkblayout all next

# 2. Get the new layout name (e.g., "English (US)")
LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true).active_keymap')

# 3. Send notification to SwayNC
# The -h string:x-canonical-private-synchronous:kb_layout part 
# makes sure the notification replaces itself rather than stacking.
notify-send -u low -t 2000 -h string:x-canonical-private-synchronous:kb_layout "Keyboard Layout Changed To:" "$LAYOUT"

# 4. Signal Waybar to update immediately
pkill -RTMIN+1 waybar
