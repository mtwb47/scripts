#!/bin/bash

interval=0

cpu() {
   cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

   printf "CPU"
   printf "$cpu_val"
}

updates() {
    updates=$(checkupdates | wc -l)

    if [ -z "$updates" ]; then
        printf "No Updates"
    else
        printf "$updates updates"
    fi
}

mem() {
    mem=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)

    printf "$mem"
} 

mail() {
    mail=$(find /home/drmdub/.local/share/mail/*/INBOX/new -type f | wc -l)

    if [ -z "$mail" ]; then
        printf "No Mail"
    else
        printf "$mail unread"
    fi
}

#weather() {

#}

clock() {
    clock=$(date '+%a, %I:%M %p')
    printf "$clock"
}

#cpu_temp() {

#}

mpd() {
    mpd=$(mpc current -f %title%)
    printf "$mpd"
}

uptime() {
    upt=$(uptime --pretty | sed -e 's/up //g' -e 's/ days/d/g' -e 's/ day/d/g' -e 's/ hours/h/g' -e 's/ hour/h/g' -e 's/ minutes/m/g' -e 's/, / /g')
    printf "$upt"
}

volume() {
    vol=$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')
    printf "$vol %"
}


#while true; do
 
#sleep 1 && xsetroot -name "$(mpd) $(updates) $(mem) $(cpu) $(mail) $(uptime) $(volume) $(clock)"
#done
while true; do
    sleep 1 && xsetroot -name "$(cpu) $(mpd) $(mem) $(mail) $(clock)"
done

