#!/bin/bash

config="$HOME/.config/alacritty/alacritty.yml"

declare -a options=(
"doom-one"
"dracula"
"gruvbox-dark"
"monokai-pro"
"nord"
"oceanic-next"
"solarized-light"
"solarized-dark"
"tomorrow-night"
"quit"
)

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -l 20 -p 'Themes')

case $choice in
    'doom-one')
        sed -i '/colors:/c\colors: *doom-one' $config ;;
    'dracula')
        sed -i '/colors:/c\colors: *dracula' $config ;;
    'gruvbox-dark')
        sed -i '/colors:/c\colors: *gruvbox-dark' $config ;;
    'monokai-pro')
        sed -i '/colors:/c\colors: *monokai-pro' $config ;;
    'nord')
        sed -i '/colors:/c\colors: *nord' $config ;;
    'oceanic-next')
        sed -i '/colors:/c\colors: *oceanic-next' $config ;;
    'solarized-light')
        sed -i '/colors:/c\colors: *solarized-light' $config ;;
    'solarized-dark')
        sed -i '/colors:/c\colors: *solarized-dark' $config ;;
    'tomorrow-night')
        sed -i '/colors:/c\colors: *tomorrow-night' $config ;;
    'quit')
        echo "No theme chosen" && exit 1 ;;
esac
