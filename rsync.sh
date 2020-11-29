#!/bin/bash


rsync -auv --delete /home /run/media/drmdub/Big\ Boy/Backups/2020/middle3
notify-send -h string:fgcolor:#ff4444 "back up running"
