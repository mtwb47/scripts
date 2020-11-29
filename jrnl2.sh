#!/bin/bash

day=$(date +"%d")
month=$(date +"%b")
year=$(date +"%Y")

#CD to Journal Directory
cd /home/drmdub/Documents/Journal

#Check to see if Year folder exists
if [ -d "/home/drmdub/Documents/Journal/"$year"/" ]; then
    cd $year
else
    mkdir $year && cd $year
fi

#Check to see if Month folder exists
if [ -d "/home/drmdub/Documents/Journal/"$year"/"$month"" ]; then
    cd $month
else
    mkdir $month && cd $month
fi

#create jnrl entry for date
touch "$day"-"$month".txt
vim "$day"-"$month".txt
