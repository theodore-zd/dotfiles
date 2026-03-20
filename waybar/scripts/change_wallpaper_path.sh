#!/usr/bin/env bash

WALLPAPER_PATH="$1"
CURRENT_WALLPAPER_FILE="$HOME/.config/hypr/current_wallpaper.txt"

if [ -z "$WALLPAPER_PATH" ] || [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: Invalid wallpaper path"
    exit 1
fi

echo "$WALLPAPER_PATH" > "$CURRENT_WALLPAPER_FILE"

MONITOR=$(hyprctl monitors -j | jq -r '.[0].name' 2>/dev/null || echo "eDP-1")

hyprctl hyprpaper wallpaper "all,${WALLPAPER_PATH}"

echo "Wallpaper changed to: $WALLPAPER_PATH"
