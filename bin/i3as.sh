



picom --config ~/.config/picom/picom.conf --experimental-backends --vsync &
#[ ! -s ~/.config/mpd/pid ] && mpd &
sxhkd -c ~/.config/i3/sxhkd/sxhkdrc &
~/.config/polybar/launch.sh &
dunst &
dropbox &
clipmenud &
xfce4-power-manager &
/usr/lib/xfce4/notifyd/xfce4-notifyd &

nitrogen --restore &



