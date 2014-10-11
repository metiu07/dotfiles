#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
xsetroot -cursor_name left_ptr
xrdb -merge ~/.Xresources
xloadimage -onroot -fullscreen /home/mato/pictures/wallpapers/archlinux1_res.jpg
#xrbd -merge .Xresources
#xpmroot ~/pictures/wallpapers/wallpaper-2692643.jpg &
setxkbmap -layout en
exec xmonad
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
