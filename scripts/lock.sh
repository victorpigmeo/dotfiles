#!/usr/bin/env bash

set -euo pipefail

LOCKSCREEN_DIR=~/.cache/lockscreen # this dir must contain a dir called 'lockscreen'


echo "Checking for existing cache/lockscreen folder"
if [ -d $LOCKSCREEN_DIR ]; then
    echo "BSPWM dir already exists"
else
    mkdir -p "$LOCKSCREEN_DIR"
fi

BLURTYPE="0x4" # http://www.imagemagick.org/Usage/blur/#blur_args

export XSECURELOCK_SAVER=saver_mpv
export XSECURELOCK_LIST_VIDEOS_COMMAND="find ${LOCKSCREEN_DIR}/lockscreen/ -type f"
export XSECURELOCK_IMAGE_DURATION_SECONDS=3600

if [ -z ${LOCKSCREEN_DIR+x} ]; then exit 1; fi # bail if lockscreen dir is not set

scrot ${LOCKSCREEN_DIR}/lockscreen-plain.png --overwrite &&
	convert ${LOCKSCREEN_DIR}/lockscreen-plain.png -blur $BLURTYPE ${LOCKSCREEN_DIR}/lockscreen-blurred.png &&
	mv ${LOCKSCREEN_DIR}/lockscreen-blurred.png ${LOCKSCREEN_DIR}/lockscreen/lockscreen.png &
xsecurelock &&
	rm  ${LOCKSCREEN_DIR}/lockscreen/lockscreen.png
