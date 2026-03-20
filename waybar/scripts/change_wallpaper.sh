#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_WALLPAPER_FILE="$HOME/.config/hypr/current_wallpaper.txt"

mkdir -p "$WALLPAPER_DIR"

if command -v zenity &> /dev/null; then
    SELECTED_WALLPAPER=$(zenity --file-selection --title="Select Wallpaper" --file-filter='Images (*.png *.jpg *.jpeg) | *.png *.jpg *.jpeg' --directory="$WALLPAPER_DIR")
elif command -v kdialog &> /dev/null; then
    SELECTED_WALLPAPER=$(kdialog --getopenurl "$WALLPAPER_DIR" "*.png *.jpg *.jpeg" --title "Select Wallpaper")
elif command -v yad &> /dev/null; then
    SELECTED_WALLPAPER=$(yad --file --directory="$WALLPAPER_DIR" --title="Select Wallpaper" --file-filter='Images | *.png *.jpg *.jpeg')
else
    echo "Error: No file picker found (need zenity, kdialog, or yad)"
    exit 1
fi

if [ -z "$SELECTED_WALLPAPER" ]; then
    exit 0
fi

if [ ! -f "$SELECTED_WALLPAPER" ]; then
    echo "Error: Selected file does not exist"
    exit 1
fi

echo "$SELECTED_WALLPAPER" > "$CURRENT_WALLPAPER_FILE"

pkill hyprpaper
sleep 0.1
hyprpaper &

sleep 1

MONITOR=$(hyprctl monitors -j | jq -r '.[0].name' 2>/dev/null || echo "eDP-1")

hyprctl hyprpaper wallpaper "all,${SELECTED_WALLPAPER}"

echo "Wallpaper changed to: $SELECTED_WALLPAPER"
