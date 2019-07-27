#! /bin/bash

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

if type "xrandr" > /dev/null; then

	# Find the primary monitor and set the correct bar
	PRIMARY_MONITOR=$(xrandr --query | grep " connected primary" | cut -d" " -f1)
	MONITOR=$PRIMARY_MONITOR polybar --reload main -c ~/.config/polybar/config &

	# Other monitors should have secondary config
	for m in $(xrandr --query | grep " connected" | grep -v " primary" | cut -d" " -f1); do
	 	MONITOR=$m polybar --reload secondary -c ~/.config/polybar/config &
	done

else
	polybar --reload main -c ~/.config/polybar/config &
fi
