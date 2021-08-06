#!/bin/sh
printf "
   @@@  @@@ @@@ @@@@@@@  @@@@@@@@    
   @@!  @@@ @@! @@!  @@@ @@!         
   @!@!@!@! !!@ @!@  !@! @!!!:!      
   !!:  !!! !!: !!:  !!! !!:         
    :   : : :   :: :  :  : :: :::    
                                   
             @@@@@                  
            @@! @@@                 
             !@!@!                  
            !!: !!!                 
             :.: : .:               
                                   
  @@@@@@ @@@@@@@@ @@@@@@@@ @@@  @@@
 !@@     @@!      @@!      @@!  !@@
  !@@!!  @!!!:!   @!!!:!   @!@@!@! 
     !:! !!:      !!:      !!: :!! 
 ::.: :  : :: ::: : :: :::  :   :::
___________________________________

HOW IT WORKS:
-Choose your difficulty level.
-If you check the directory you ran
this in you'll now find a folder
named 'hideandseek' - move into it.
-Based on your difficulty there will
be anywhere from 25-100 files inside
this directory, now find the files
that contain 'hider' in them.

ENTER YOUR DIFFICULTY:
e) Easy   n) Normal   h) Hard
 2 Hiders  4 Hiders    8 Hiders

TOO SCARED?
q) quit

"

while true; do
	read -p "> " difficulty
	case $difficulty in
	[eE]* ) dir='hideandseek'
		mkdir -p $dir
		cd $dir
		touch $(paste -d '.' <(printf "%s\n" File{001..025}) \
                    <(printf "%s\n" {000..024}))
		N=2
		ls |sort -R |tail -$N |while read file; do
			echo "hider" >> $file
		done
		exit ;;
	[nN]* ) dir='hideandseek'
		mkdir -p $dir
		cd $dir
		touch $(paste -d '.' <(printf "%s\n" File{001..050}) \
                    <(printf "%s\n" {000..049}))
		N=4
		ls |sort -R |tail -$N |while read file; do
			echo "hider" >> $file
		done
		exit ;;
	[hH]* ) dir='hideandseek'
		mkdir -p $dir
		cd $dir
		touch $(paste -d '.' <(printf "%s\n" File{001..100}) \
                    <(printf "%s\n" {000..099}))
		N=8
		ls |sort -R |tail -$N |while read file; do
			echo "hider" >> $file
		done
		exit ;;
	[qQ]* ) exit ;;
	esac
done

exit

