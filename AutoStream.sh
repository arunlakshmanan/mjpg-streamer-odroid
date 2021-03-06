#!/bin/bash

usage()
{
cat << EOF

 Usage     : ./Stream.sh  --[options]

This script auto-sets parameters and starts running mjpeg-streamer.

OPTIONS:
 --stopx   : This stops the xserver on Odroid, improving performance.
	     This is a required option.
 --startx  : Restarts xserver after script execution

EOF
}

if ! [[ "$*" =~ "--stopx" ]]
then
	usage
	exit 0
else
	sudo service lightdm stop
	export LD_LIBRARY_PATH=.
	sudo modprobe uvcvideo
	v4l2-ctl --set-fmt-video=width=864,height=480,pixelformat=2
	v4l2-ctl --set-parm=30
	v4l2-ctl -c focus_auto=0
	sudo ./mjpg_streamer -i "./input_uvc.so -fps 20 -r 864x480 -d /dev/video0 -n" -o "./output_http.so -w ./www -p 8090"

	if [[ "$*" =~ "--startx" ]]
	then
		sudo service lightdm start
	fi
fi
