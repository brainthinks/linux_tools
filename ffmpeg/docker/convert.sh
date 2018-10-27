#!/usr/bin/env bash

INPUT_FILE="$1"
OUTPUT_FILE="$2"
DESTINATION="/media/user/linux_storage/videos/obs_recordings"

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
  -v "$INPUT_FILE:/root/inputvideo.mkv" \
  -v "$DESTINATION:/root/videos" \
  ffmpeg \
  ffmpeg \
    -i "/root/inputvideo.mkv" \
    -c:v libx264 -crf 17 \
    -c:a libmp3lame -b:a 192k \
    "/root/videos/$OUTPUT_FILE"
