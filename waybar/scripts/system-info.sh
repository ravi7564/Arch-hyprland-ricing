#!/usr/bin/env bash

# -------- CPU USAGE --------
CPU=$(awk '/^cpu / {
  usage=($2+$4)*100/($2+$4+$5)
  printf "%.0f%%", usage
}' /proc/stat)

# -------- CPU TEMP --------
CPU_TEMP="N/A"
for hw in /sys/class/hwmon/hwmon*; do
  name=$(cat "$hw/name")
  if [[ "$name" == "coretemp" || "$name" == "k10temp" ]]; then
    raw=$(cat "$hw"/temp*_input 2>/dev/null | head -n1)
    [[ -n "$raw" ]] && CPU_TEMP="$((raw / 1000))°C"
  fi
done

# -------- GPU USAGE --------
GPU="N/A"
if command -v nvidia-smi &>/dev/null; then
  GPU="$(nvidia-smi --query-gpu=utilization.gpu \
       --format=csv,noheader,nounits | head -n1)%"
fi

# -------- GPU TEMP (FIXED) --------
GPU_TEMP="N/A"
if command -v nvidia-smi &>/dev/null; then
  GPU_TEMP="$(nvidia-smi --query-gpu=temperature.gpu \
              --format=csv,noheader,nounits | head -n1)°C"
fi

# -------- RAM --------
RAM=$(free -m | awk '/Mem:/ {printf "%.0f%%", $3/$2 * 100}')

# ================= BACKLIGHT =================
BL_DEV="/sys/class/backlight/nvidia_0"
BL="N/A"

if [[ -f "$BL_DEV/brightness" && -f "$BL_DEV/max_brightness" ]]; then
  CUR=$(cat "$BL_DEV/brightness")
  MAX=$(cat "$BL_DEV/max_brightness")
  BL="$(( CUR * 100 / MAX ))%"
fi

# ---------------- OUTPUT -------------------
echo " $CPU $CPU_TEMP   󰢮 $GPU $GPU_TEMP    $RAM    $BL"
