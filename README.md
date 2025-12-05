# Arch-hyprland-ricing
customize hyprland arch linux, endevour os.
ramove minimize maximize and close button gtk all apps-- 
gsettings set org.gnome.desktop.wm.preferences button-layout ':'
---this command will remove minimize,maximiza and close button from all gtk apps.
i am using:
nwg-look for managing theme and icon and related setting for all gtkk apps.
kvantummanager for managing kde settings and apps with qt5ct and qt6ct.
network-manager-applet  for managing wifi with hyprpanel
bluez bluez-utils  for managing bluetooth
brightnessctl   for managing brightness for keyboard


if you dont want to use any login manager like gdm, sddm, lightdm then 
use tty1 for login.
if you want to auto login and start hyprland automatically then make a .zprofile file and paste following 
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=hyprland
    exec dbus-run-session hyprland
fi

then add exec-once hyprlock to the top oof the hyprland.conf file.
also add this:
[Service]
ExecStart=
ExecStart= -/usr/bin/agetty --noissue --autologin ravi --noclear %I $TERM
to
/etc/systemd/system/getty@tty1.service.d/override.conf
then save.
