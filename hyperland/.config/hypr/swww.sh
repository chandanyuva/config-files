#!/bin/bash
WALLPAPER_DIR=~/.wallpapers/ # Change to your wallpaper directory
TRANSITION_TYPE="random" # Or "simple", "outer", "center", etc.

# Ensure swww is running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon --format xrgb & # Start daemon if not running
    sleep 1 # Give it a moment to initialize
fi

# Get a list of image files (adjust extensions as needed)
files=("$WALLPAPER_DIR"/*.{jpg,png,jpeg,gif})

# Check if there are any wallpapers
if [ ${#files[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

while true; do
    # Select a random image from the list
    random_image="${files[RANDOM % ${#files[@]}]}"

    # Load the wallpaper with a transition
    swww img "$random_image" --transition-type "$TRANSITION_TYPE" --transition-fps 60 --transition-step 90

    # Sleep for a duration (e.g., 30 minutes) before the next change
    sleep 10m
done

