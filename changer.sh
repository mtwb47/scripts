#!/bin/bash
# Author: Matthew Weber AKA The Linux Cast
# Version: 0.1 
# Description: This script allows you to change between several DWM Rices.
# Dependencies: pkexec, sed, git, polkit, rofi
# WARNING: In order for this script to work, you will eventually be asked for a root password. In order for this to happen, you will need a polkit agent installed and running. 

##########################################################################

themedir = "$HOME/.config/suckless/dwm/themes/"
config = "$HOME/.config/suckless/dwm/config.def.h"
hfile = "$HOME/.config/suckless/dwm/config.h"
declare -a options=(
    "dracula"
    "gruvbox"
    "monokai"
    "ocean"
    "purple"
    "quit"
)

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -l -20 -p 'Themes')

case $choice in
    'dracula')
        sed -i '/#include/c\#include "$themedir"/dracula' $config && rm "$hfile" && make
