#! /bin/sh

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

desktop=$(echo $DESKTOP_SESSION)

# TODO: Remove other wm
case $desktop in
    i3)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	if [ $m == 'eDP1' ] 
	then		
		MONITOR=$m polybar --reload main -c ~/.config/polybar/config &	
	elif [ $m == 'DP2' ]
	then
		MONITOR=$m polybar --reload sidebar-1-i3 -c ~/.config/polybar/config &
	else
		MONITOR=$m polybar --reload sidebar-2-i3 -c ~/.config/polybar/config &
	fi     
      done
    else
    polybar --reload main -c ~/.config/polybar/config &
    fi
    ;;
    openbox)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-openbox -c ~/.config/polybar/config &
      done
    else
    polybar --reload mainbar-openbox -c ~/.config/polybar/config &
    fi
#    if type "xrandr" > /dev/null; then
#      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#        MONITOR=$m polybar --reload mainbar-openbox-extra -c ~/.config/polybar/config &
#      done
#    else
#    polybar --reload mainbar-openbox-extra -c ~/.config/polybar/config &
#    fi

    ;;
    bspwm)
    if type "xrandr" > /dev/null; then
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-bspwm -c ~/.config/polybar/config &
      done
    else
    polybar --reload mainbar-bspwm -c ~/.config/polybar/config &
    fi
    ;;
esac
