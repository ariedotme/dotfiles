#!/bin/bash

# File to store the toggle state
STATE_FILE="/tmp/vim_mode_toggle"

# Initialize the state if the file doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "off" > "$STATE_FILE"
fi

# Read the current state
STATE=$(cat "$STATE_FILE")

if [ "$STATE" == "off" ]; then
    # Enable Vim navigation mode
    xmodmap -e "keycode 43 = Left"  # h -> Left
    xmodmap -e "keycode 44 = Down"  # j -> Down
    xmodmap -e "keycode 45 = Up"    # k -> Up
    xmodmap -e "keycode 46 = Right" # l -> Right

    # Unbind physical arrow keys
    xmodmap -e "keycode 111 = NoSymbol"  # Up Arrow
    xmodmap -e "keycode 116 = NoSymbol"  # Down Arrow
    xmodmap -e "keycode 113 = NoSymbol"  # Left Arrow
    xmodmap -e "keycode 114 = NoSymbol"  # Right Arrow

    echo "on" > "$STATE_FILE"
else
    # Disable Vim navigation mode (restore regular typing)
    xmodmap -e "keycode 43 = h H"
    xmodmap -e "keycode 44 = j J"
    xmodmap -e "keycode 45 = k K"
    xmodmap -e "keycode 46 = l L"

    # Rebind physical arrow keys
    xmodmap -e "keycode 111 = Up"    # Up Arrow
    xmodmap -e "keycode 116 = Down"  # Down Arrow
    xmodmap -e "keycode 113 = Left"  # Left Arrow
    xmodmap -e "keycode 114 = Right" # Right Arrow

    echo "off" > "$STATE_FILE"
fi

