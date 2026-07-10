#!/usr/bin/env bash

xrandr --output eDP-1 --mode 1920x1200 --rate 60 --primary
xrandr --output DP-2 --mode 1920x1080 --rate 60 --right-of eDP-1
