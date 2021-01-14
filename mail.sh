#!/bin/sh

# Displays number of unread mail and an loading icon if updating.
# When clicked, brings up `neomutt`.


unread="$(find "${XDG_DATA_HOME:-$HOME/.local/share}"/mail/*/[Ii][Nn][Bb][Oo][Xx]/new/* -type f | wc -l 2>/dev/null)"

pidof mbsync >/dev/null 2>&1 && icon="ﮮ"

[ "$unread" = "0" ] && [ "$icon" = "" ] || echo " $icon"
