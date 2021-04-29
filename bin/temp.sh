#!/bin/bash


sensors >> $HOME/.config/.temps
grep Tdie $HOME/.config/.temps | sed 's/Tdie://g' | sed 's/ //g' | sed 's/+//g' >> $HOME/.temp
