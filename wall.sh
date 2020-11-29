#!/usr/bin/bash
echo "What is the path to your wallpaper?"
read -e -p 'Path: ' wallpath
#feh --bg-scale $wallpath
wal -i $wallpath 
