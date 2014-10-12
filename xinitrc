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

# Add fonts in X
xset +fp /usr/share/fonts/
xset fp rehash

# Compose key
setxkbmap -option compose:ralt

# Load Xmodmap
xmodmap ~/.Xmodmap

# Transparency 
xcompmgr &

# Clipboard
autocutsel -fork
autocutsel -selection PRIMARY -fork
autocutsel -selection CLIPBOARD -fork

# Screensaver
xscreensaver -no-splash &

exec dwm
