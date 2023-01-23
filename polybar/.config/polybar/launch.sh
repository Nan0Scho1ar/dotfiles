#!/usr/bin/env sh

# More info : https://github.com/jaagr/polybar/wiki

# Install the following applications for polybar and icons in polybar if you are on ArcoLinuxD
# awesome-terminal-fonts
# Tip : There are other interesting fonts that provide icons like nerd-fonts-complete

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

desktop=$(echo $DEFAULT_SESSION)
[ -q $desktop ] && desktop=bspwm
count=$(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l)

echo "Desktop = $desktop"
echo "Count = $count"

echo '$1=' "$1"
case $1 in
    top) top=t; bottom= ;;
    bottom) top= ; bottom=t ;;
    both) top=t; bottom=t ;;
    none) top= ; bottom= ;;
    *) echo "setting both"
        top=t; bottom=t ;;
esac

echo "$desktop"
echo "DISPLAY=$DISPLAY"
case $desktop in

    i3|/usr/share/xsessions/i3)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-i3 -c ~/.config/polybar/config &
      done
    else
    polybar --reload mainbar-i3 -c ~/.config/polybar/config &
    fi
    # second polybar at bottom
    # if type "xrandr" > /dev/null; then
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-i3-extra -c ~/.config/polybar/config &
    #   done
    # else
    # polybar --reload mainbar-i3-extra -c ~/.config/polybar/config &
    # fi
    ;;

    openbox|/usr/share/xsessions/openbox)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-openbox -c ~/.config/polybar/config &
      done
    else
    polybar --reload mainbar-openbox -c ~/.config/polybar/config &
    fi
    # second polybar at bottom
    # if type "xrandr" > /dev/null; then
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-openbox-extra -c ~/.config/polybar/config &
    #   done
    # else
    # polybar --reload mainbar-openbox-extra -c ~/.config/polybar/config &
    # fi
    ;;

    bspwm|/usr/share/xsessions/bspwm)
        if [ $HOSTNAME == "jupiter" ]; then
            MONITOR=DisplayPort-2 BARNUM=1 polybar --reload mainbar-bspwm-1     -c ~/.config/polybar/config &
            MONITOR=DisplayPort-2 BARNUM=1 polybar --reload mainbar-aesthetic-1 -c ~/.config/polybar/config &

            MONITOR=DisplayPort-1 BARNUM=2 polybar --reload mainbar-bspwm-2     -c ~/.config/polybar/config &
            MONITOR=DisplayPort-1 BARNUM=2 polybar --reload mainbar-aesthetic-2 -c ~/.config/polybar/config &

            MONITOR=DisplayPort-0 BARNUM=3 polybar --reload mainbar-bspwm-3     -c ~/.config/polybar/config &
            MONITOR=DisplayPort-0 BARNUM=3 polybar --reload mainbar-aesthetic-3 -c ~/.config/polybar/config &

            MONITOR=DVI-D-1-1     BARNUM=4 polybar --reload mainbar-bspwm-4     -c ~/.config/polybar/config &
            MONITOR=DVI-D-1-1     BARNUM=4 polybar --reload mainbar-aesthetic-4 -c ~/.config/polybar/config &

            MONITOR=HDMI-A-0      BARNUM=5 polybar --reload mainbar-bspwm-5     -c ~/.config/polybar/config &
            MONITOR=HDMI-A-0      BARNUM=5 polybar --reload mainbar-aesthetic-5 -c ~/.config/polybar/config &

            MONITOR=HDMI-1-2      BARNUM=6 polybar --reload mainbar-bspwm-6     -c ~/.config/polybar/config &
            MONITOR=HDMI-1-2      BARNUM=6 polybar --reload mainbar-aesthetic-6 -c ~/.config/polybar/config &
        else
            echo "loading bspwm bars..."
            if [ ! -z "$top" ]; then
                echo "Loading top bar"
                if type "xrandr" > /dev/null; then
                barnum=1
                for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
                    echo "Barnum= $barnum"
                    echo "MONITOR=$m polybar --reload mainbar-bspwm-$barnum -c ~/.config/polybar/config"
                    MONITOR=$m polybar --reload mainbar-bspwm-$barnum -c ~/.config/polybar/config &
                    barnum=$((barnum+1))
                done
                else
                polybar --reload mainbar-bspwm-1 -c ~/.config/polybar/config &
                fi
                bspc config top_padding 19
            else
                bspc config top_padding 0
            fi
            #second polybar at bottom
            if [ ! -z "$bottom" ]; then
                echo "Loading bottom bar"
                if type "xrandr" > /dev/null; then
                barnum=1
                for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
                    MONITOR=$m polybar --reload mainbar-aesthetic-$barnum -c ~/.config/polybar/config &
                    barnum=$((barnum+1))
                done
                else
                polybar --reload mainbar-aesthetic-1 -c ~/.config/polybar/config &
                fi
            fi
        fi
        ;;

    herbstluftwm|/usr/share/xsessions/herbstluftwm)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-herbstluftwm -c ~/.config/polybar/config &
      done
    else
    polybar --reload mainbar-herbstluftwm -c ~/.config/polybar/config &
    fi
    # second polybar at bottom
    # if type "xrandr" > /dev/null; then
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-herbstluftwm-extra -c ~/.config/polybar/config &
    #   done
    # else
    # polybar --reload mainbar-herbstluftwm-extra -c ~/.config/polybar/config &
    # fi
    ;;

    xmonad|/usr/share/xsessions/xmonad)
    if [ $count = 1 ]; then
      m=$(xrandr --query | grep " connected" | cut -d" " -f1)
      MONITOR=$m polybar --reload mainbar-xmonad -c ~/.config/polybar/config &
    else
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-xmonad -c ~/.config/polybar/config &
      done
    fi
    # second polybar at bottom
    # if [ $count = 1 ]; then
    #   m=$(xrandr --query | grep " connected" | cut -d" " -f1)
    #   MONITOR=$m polybar --reload mainbar-xmonad-extra -c ~/.config/polybar/config &
    # else
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-xmonad-extra -c ~/.config/polybar/config &
    #   done
    # fi
    ;;

spectrwm|/usr/share/xsessions/spectrwm)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-spectrwm -c ~/.config/polybar/config &
      done
    else
    polybar --reload mainbar-spectrwm -c ~/.config/polybar/config &
    fi
    ;;

esac
