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

swaync for notification
if you dont want to use any login manager like gdm, sddm, lightdm then 
for autologin and then hyprlock to lock:
sudo systemctl edit getty@tty1
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin ravi --skip-login --noclear %I $TERM
Type=simple

then go to this location /home/ravi/.config/systemd/user/  then make a file
hyprland.service and paste this:
[Unit]
Description=Hyprland Wayland Session
After=graphical-session-pre.target
Wants=graphical-session-pre.target

[Service]
ExecStart=/usr/bin/Hyprland
Restart=always
RestartSec=1
Environment=XDG_SESSION_TYPE=wayland
Environment=XDG_CURRENT_DESKTOP=Hyprland

[Install]
WantedBy=default.target

then enable system service
systemctl --user enable hyprland.service.
then add exec-once hyprlock to the top of the hyprland.conf file.
