#!/usr/bin/env bash

DESTINATION="/media/user/linux_storage/videos/obs_recordings"
FILE_NAME="$(date +%F-%s).mkv"

echo "Press q to quit recording..."

docker container run -ti \
  --rm \
  --device=/dev/nvidia0:/dev/nvidia0 \
  --device=/dev/nvidiactl:/dev/nvidiactl \
  --device=/dev/nvidia-uvm:/dev/nvidia-uvm \
  -e DISPLAY=$DISPLAY \
  -e "XAUTHORITY=/home/$USER/.Xauthority" \
  -e "PULSE_SERVER=unix:/root/pulsesocket" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix" \
  -v "/run/user/$UID/pulse/native:/root/pulsesocket" \
  -v "$DESTINATION:/root/videos" \
  ffmpeg \
  ffmpeg \
    -y \
    -loglevel error \
    -probesize 25M \
    -framerate 60 \
    -video_size 1920x1080 \
    -thread_queue_size 1024 \
    -f x11grab -i $DISPLAY+1920,0 \
    -thread_queue_size 1024 \
    -f pulse -i alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-stereo.monitor \
    -thread_queue_size 1024 \
    -f pulse -i alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-mono \
    -filter_complex amix=inputs=2[mix] \
    -map 0:v \
    -map '[mix]' \
    -map 1:a \
    -map 2:a \
    -c:v libx264 -b:v 25000k \
    -preset ultrafast -crf 0 \
    "/root/videos/$FILE_NAME"
