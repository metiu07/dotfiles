#! /bin/sh

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

if type "xrandr" > /dev/null; then
    monitors_num=$(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l)
    if [ $monitors_num -eq 1 ]
    then
	echo "Only one monitor"
	m=$(xrandr --query | grep " connected" | cut -d" " -f1)
	xrandr --output $m
	MONITOR=$m polybar --reload main -c ~/.config/polybar/config &
    elif [ $monitors_num -eq 2 ]
    then
	echo "Two monitors"
	~/.config/polybar/home.sh
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	    if [ $m == "DP2" ]
	    then
		echo "Main monitor"
		MONITOR=$m polybar --reload main -c ~/.config/polybar/config &	
	    else
		MONITOR=$m polybar --reload secondary -c ~/.config/polybar/config &
	    fi
	done
    elif [ $monitors_num -eq 3 ]
    then
	echo "Three monitors"
	~/.config/polybar/work.sh
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	    if [ $m == "DP1-1" ]
	    then
		echo "Main monitor"
		MONITOR=$m polybar --reload main -c ~/.config/polybar/config &
	    else
		MONITOR=$m polybar --reload secondary -c ~/.config/polybar/config &
	    fi
	done
    else
	echo "Multiple monitors"
	xrandr --output eDP1 --right-of DP2
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	    echo "Monitor: $m"
	    if [ $m == 'DP2' ] || [ $m == 'DP1-1']
	    then
		MONITOR=$m polybar --reload main -c ~/.config/polybar/config &	
	    elif [ $m == 'eDP1' ]
	    then
		MONITOR=$m polybar --reload secondary -c ~/.config/polybar/config &
	    else
		MONITOR=$m polybar --reload secondary -c ~/.config/polybar/config &
	    fi
	done
    fi
else
    polybar --reload main -c ~/.config/polybar/config &
fi
