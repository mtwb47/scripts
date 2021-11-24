#!/bin/python
# -*- coding: utf-8 -*-

# Procedure
# Surf to https://openweathermap.org/city
# Fill in your CITY
# e.g. Antwerp Belgium
# Check url
# https://openweathermap.org/city/2803138
# you will the city code at the end
# create an account on this website
# create an api key (free)
# LANG included thanks to krive001 on discord


import requests

CITY = "YOUR LOCATION HERE"
API_KEY = "EDIT YOUR API KEY HERE!"
UNITS = "imperial"
#UNIT_KEY = "C"
UNIT_KEY = "F"
LANG = "en"
#LANG = "nl"
#LANG = "hu"

REQ = requests.get(f"http://api.openweathermap.org/data/2.5/weather?id={CITY}&lang={LANG}&appid={API_KEY}&units={UNITS}")
try:
    # HTTP CODE = OK
    if REQ.status_code == 200:
        CURRENT = REQ.json()["weather"][0]["description"].capitalize()
        TEMP = int(float(REQ.json()["main"]["temp"]))
        print(f"{CURRENT}, {TEMP} °{UNIT_KEY}")
    else:
        print(f"Error: BAD HTTP STATUS CODE {REQ.status_code}")
except (ValueError, IOError):
    print("Error: Unable print the data")
