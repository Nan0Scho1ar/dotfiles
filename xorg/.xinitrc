#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ "$HOSTNAME" == "earth" ]; then
    export DEFAULT_SESSION=bspwm
else
    DEFAULT_SESSION=startplasma-x11
fi

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

get_session(){
    local dbus_args=(--sh-syntax --exit-with-session)
    case $1 in
        bspwm) dbus_args+=(bspwm-session) ;;
        gnome) dbus_args+=(gnome-session) ;;
        kde) dbus_args+=(startplasma-x11) ;;
        *) dbus_args+=($DEFAULT_SESSION) ;;
    esac

    echo "dbus-launch ${dbus_args[*]}"
}

#feh --bg-scale /home/nan0scho1ar/Pictures/helix.png
if [ "$DEFAULT_SESSION" = "bspwm" ]; then
    $HOME/.config/autostart.sh
fi
exec $(get_session "$1")
xset r rate 600 25
sleep 1
