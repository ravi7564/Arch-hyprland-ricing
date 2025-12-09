if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=hyprland
    exec dbus-run-session hyprland
fi

# go to the location  /etc/systemd/system/getty@tty1.service.d/override.conf and paste

# [Service]
# ExecStart=
# ExecStart= -/usr/bin/agetty --noissue --autologin ravi --noclear %I $TERM
# then  make a file in home folder .zprofile and paste
# if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
#     export XDG_SESSION_TYPE=wayland
#     export XDG_SESSION_DESKTOP=hyprland
#     exec dbus-run-session hyprland
# fi
# at the op of .zprofile.
