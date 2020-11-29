#!/usr/bin/bash
echo "What is the name of the album you are downloading?"
read -e -p "Album Name:" albumname
echo "What is the name of the artist?"
read -e -p "Artist Name:" artistname
echo "What is the URL of the playlist you wish to download"
read -e -p "URL: " urlpath

cd /run/media/drmdub/Big\ Boy/Media/Music/"$artistname"
mkdir "$albumname"
cd "$albumname"
youtube-dl -o "%(title)s.%(ext)s" -x --audio-format mp3 --yes-playlist --embed-thumbnail "$urlpath"
