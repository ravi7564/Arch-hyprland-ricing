#!/bin/bash

pkill -f "yad.*Volume"

# Get current output volume
output_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

# Get screen width for positioning (Optional: Hyprland rules might override this)
screen_width=$(hyprctl monitors -j | jq '.[0].width')
x_pos=$(( (screen_width - 350) / 2 ))


yad --scale --title="Volume" --value="$output_vol" \
    --min-value=0 --max-value=150 --step=1 \
    --width=350 --height=80 \
    --print-partial --no-buttons \
    --close-on-unfocus \
    --geometry="350x80+${x_pos}+50" | while read vol; do
    clean_vol=$(echo "$vol" | tr -d '|')
    pactl set-sink-volume @DEFAULT_SINK@ "${vol}%"
done
