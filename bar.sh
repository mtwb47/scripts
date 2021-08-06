#!/bin/bash

interval=0

weather() {
    weather=$(python3 /usr/local/bin/weather.py)

  printf "^c#3b414d^ ^b#A3BE8C^ W"
  printf "^c#3b414d^ ^b#A3BE8C^ $weather"
}


cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c#3b414d^ ^b#A3BE8C^ CPU"
  printf "^c#abb2bf^ ^b#414753^ $cpu_val"
}

update_icon() {
  printf "^c#94af7d^ "
}

# only for void users!
updates() {
  updates=$(checkupdates | wc -l)

  if [ -z "$updates" ]; then
    printf "^c#94af7d^ Fully Updated"
  else
    printf "^c#94af7d^ $updates updates"
  fi
}

# battery
batt() {
  printf "^c#81A1C1^  "
  printf "^c#81A1C1^ $(acpi | sed "s/,//g" | awk '{if ($3 == "Discharging"){print $4; exit} else {print $4""}}' | tr -d "\n")"
}

brightness() {

  backlight() {
    backlight="$(xbacklight -get)"
    echo -e "$backlight"
  }

  printf "^c#BF616A^   "
  printf "^c#BF616A^%.0f\n" $(backlight)
}

mem() {
  printf "^c#7797b7^^b#2E3440^  "
  printf "^c#7797b7^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
  case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
  up) printf "^c#3b414d^ ^b#7681c5^ 󰤨 ^d^%s" " ^c#828dd1^Connected" ;;
  down) printf "^c#3b414d^ ^b#7681c5^ 󰤨 ^d^%s" " ^c#828dd1^Disconnected" ;;
  esac
}

clock() {
  printf "^c#2E3440^ ^b#828dd1^  "
  printf "^c#2E3440^^b#6c77bb^ $(date '+%a, %I:%M %p') "
}

while true; do

  # remove these 2 lines if u dont use void! or adjust the xbps-updates to get n.o of updates (according your distro ofc)
  [ $interval == 0 ] || [ $(($interval % 3600)) == 0 ] && updates=$(updates)
  interval=$((interval + 1))

 [ $interval == 0 ] || [ $(($interval % 3600)) == 0 ] && weather=$(weather)
  interval=$((interval + 1))


  sleep 1 && xsetroot -name "$(weather) $(update_icon) $updates $(cpu) $(mem) $(clock)"
done

