#!/bin/bash
############### My Dots to Repo Converter ################
# Author: Matthew A. Weber AKA The Linux Cast
# Version: 1.1
# First Version Released 08-05-2021
# Last Edited: 08-07-2021
# GPL V3
# Desc: Moves dotfiles from .config folder to cust om repo, then creates symlinks back to .config
# Currently Supported Dots: Alacritty, BSPWM, i3, AwesomeWM
##########################################################

#Define Repo Location 
repo=$HOME/myrepo

#Define Colors
red='\033[0;31m'
nc='\033[0m' #Back in Black

#DO Warning about config backup

printf "

     ${red}WARNING!${nc} 

     This script will ${red}move${nc} directories from your .config directory 
     into a directory called ${red}myrepo${nc} in your HOME directory.
     
     It does attempt to make a backup. The backup file will be located in your 
     HOME Directory if it is needed.

     "

read -p "Are You Sure You'd Like to Continue? [Y/n] " input
 
case $input in
    [yY][eE][sS]|[yY])
 echo "Yes"
 ;;
    [nN][oO]|[nN])
 exit
       ;;
    *)
 echo "Invalid input..."
 exit 1
 ;;
esac

#Check if config file exists.
if [ -d "$HOME/.config" ]; then
    printf ".config file exists, script will continue \n"
else
    exit
fi

#Make Repo
if [ ! -f $repo ]; then
    mkdir $repo
else
    printf "Repo Already Exists"
fi

#Backup Congig file if Config File exists
if [ -d "$HOME/.config/" ]; then
    cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)
else
    echo "Where is your .config file, you hooligan?"
fi

#BSPWM
if [ -d "$HOME/.config/bspwm" ]; then
    mv $HOME/.config/bspwm "$repo" && ln -s "$repo"/bspwm $HOME/.config/bspwm
else
    echo "no bspwm"
fi

#i3wm
if [ -d "$HOME/.config/i3" ]; then
    mv $HOME/.config/i3 "$repo" && ln -s "$repo"/i3 $HOME/.config/i3
else
    echo "no i3"
fi

#awesome
if [ -d "$HOME/.config/awesome" ]; then
    mv $HOME/.config/awesome "$repo" && ln -s "$repo"/awesome $HOME/.config/awesome
else
    echo "no bspwm"
fi

#alacritty
if [ -d "$HOME/.config/alacritty" ]; then
    mv $HOME/.config/alacritty "$repo" && ln -s "$repo"/alacritty $HOME/.config/alacritty
else
    echo "no alacritty"
fi

printf "
    If the script succeeded, delete the backup of your config file, 
    as it does take up a lot of HDD space. 

    All That's left to do is create your git repo online and git init"
