#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_WALLPAPER_FILE="$HOME/.config/hypr/current_wallpaper.txt"

mkdir -p "$WALLPAPER_DIR"

wallpapers=()
counter=1

for file in "$WALLPAPER_DIR"/*.{png,jpg,jpeg,JPG,PNG,JPEG} 2>/dev/null; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        wallpapers+=("$filename|$file")
        ((counter++))
    fi
done

if [ ${#wallpapers[@]} -eq 0 ]; then
    echo '{"title":"No Wallpapers","description":"No wallpapers found in $WALLPAPER_DIR"}'
    exit 0
fi

echo '{"items":['
first=true
for item in "${wallpapers[@]}"; do
    IFS='|' read -r name path <<< "$item"
    if [ "$first" = true ]; then
        first=false
    else
        echo ','
    fi
    echo "{\"title\":\"$name\",\"description\":\"Set as wallpaper\",\"command\":\"~/.config/waybar/scripts/change_wallpaper_path.sh '$path'\"}"
done
echo ']}'
