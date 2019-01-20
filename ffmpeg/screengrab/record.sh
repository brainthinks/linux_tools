#!/usr/bin/env bash

DESTINATION="/media/user/linux_storage/videos/obs_recordings"
FILE_NAME="$(date +%F-%s).mkv"

WIDTH="1920"
HEIGHT="1080"
RESOLUTION="${WIDTH}x${HEIGHT}"
LOCAL_DISPLAY=":0" # @todo - use the $DISPLAY value as the default

WHAT_U_HEAR="alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-stereo.monitor"
MIC="alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-mono"

# I don't know what this does
PROBESIZE="25M"
# I don't know what this does
THREAD_QUEUE_SIZE="1024"

echo "Press q to quit recording..."

./ffmpeg \
  -y \
  -loglevel error \
  -probesize "$PROBESIZE" \
  -framerate 60 \
  -video_size "$RESOLUTION" \
  -thread_queue_size "$THREAD_QUEUE_SIZE" \
  -f x11grab -i "${LOCAL_DISPLAY}+${WIDTH},0" \
  -thread_queue_size "$THREAD_QUEUE_SIZE" \
  -f pulse -i "$WHAT_U_HEAR" \
  -thread_queue_size "$THREAD_QUEUE_SIZE" \
  -f pulse -i "$MIC" \
  -filter_complex amix=inputs=2[mix] \
  -map 0:v \
  -map '[mix]' \
  -map 1:a \
  -map 2:a \
  -c:v libx264 -b:v 25000k \
  -preset ultrafast -crf 0 \
  "$DESTINATION/$FILE_NAME"
