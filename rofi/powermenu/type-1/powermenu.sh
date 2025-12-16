#!/usr/bin/env bash

# =========================
# Config
# =========================
dir="$HOME/.config/rofi/powermenu/type-1"
theme="style-1"

uptime="$(uptime -p | sed 's/up //')"
host="$(hostname)"

# =========================
# Icons & Labels
# =========================
shutdown="  Shutdown"
reboot="  Reboot"
lock="  Lock"
suspend="  Suspend"
logout="  Logout"

yes="  Yes"
no="  No"

# =========================
# Rofi Commands
# =========================
rofi_cmd() {
  rofi -dmenu \
    -p "$host" \
    -mesg "Uptime: $uptime" \
    -theme "${dir}/${theme}.rasi"
}

confirm_cmd() {
  rofi -dmenu \
    -p "Confirmation" \
    -mesg "Are you sure?" \
    -theme-str 'window { width: 260px; }' \
    -theme-str 'listview { columns: 2; lines: 1; }' \
    -theme-str 'element-text { horizontal-align: 0.5; }' \
    -theme "${dir}/${theme}.rasi"
}

confirm_exit() {
  printf "%s\n%s" "$yes" "$no" | confirm_cmd
}

run_rofi() {
  printf "%s\n%s\n%s\n%s\n%s" \
    "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | rofi_cmd
}

# =========================
# Actions
# =========================
run_cmd() {
  [[ "$(confirm_exit)" != "$yes" ]] && exit 0

  case "$1" in
    shutdown)
      systemctl poweroff
      ;;
    reboot)
      systemctl reboot
      ;;
    suspend)
      playerctl pause 2>/dev/null
      systemctl suspend
      ;;
    logout)
      hyprctl dispatch exit
      ;;
  esac
}

# =========================
# Main
# =========================
chosen="$(run_rofi)"

case "$chosen" in
  "$shutdown") run_cmd shutdown ;;
  "$reboot")   run_cmd reboot ;;
  "$lock")     hyprlock ;;
  "$suspend")  run_cmd suspend ;;
  "$logout")   run_cmd logout ;;
esac
