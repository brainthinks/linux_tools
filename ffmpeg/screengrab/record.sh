#!/usr/bin/env bash

# output file configuration
DESTINATION="/media/user/ffmpeg_capture"
TIME_LABEL="$(date +%F_%T_%s)"
FILE_NAME="${TIME_LABEL}_${1:-""}.mkv"

# video configuration
FRAMERATE="60"
VIDEO_BITRATE="12500"
WIDTH="1920"
HEIGHT="1080"
RESOLUTION="${WIDTH}x${HEIGHT}"
LOCAL_DISPLAY=":0" # @todo - use the $DISPLAY value as the default

# for display 0
# GRAB_AREA="${LOCAL_DISPLAY}+0,0"
# for display 1 (second monitor)
GRAB_AREA="${LOCAL_DISPLAY}+${WIDTH},0"

# audio sources
WHAT_U_HEAR="alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-stereo.monitor"
MIC="alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-mono"

# I don't know what this does
PROBESIZE="25M"
# I don't know what this does
THREAD_QUEUE_SIZE="1024"

echo "Screengrabbing started at $(date +%T)"
echo "Capturing to file ${DESTINATION}/${FILE_NAME}"
echo ""
echo "Press q to stop screengrabbing..."

ffmpeg \
  -y \
  -loglevel error \
  -probesize "${PROBESIZE}" \
  -framerate "${FRAMERATE}" \
  -video_size "${RESOLUTION}" \
  -thread_queue_size "${THREAD_QUEUE_SIZE}" \
  -f x11grab -i "${GRAB_AREA}" \
  -thread_queue_size "${THREAD_QUEUE_SIZE}" \
  -f pulse -i "${WHAT_U_HEAR}" \
  -thread_queue_size "${THREAD_QUEUE_SIZE}" \
  -f pulse -i "${MIC}" \
  -filter_complex amix=inputs=2[mix] \
  -map 0:v \
  -map '[mix]' \
  -map 1:a \
  -map 2:a \
  -c:v libx264 \
  -b:v "${VIDEO_BITRATE}k" \
  -preset ultrafast \
  -crf 17 \
  "${DESTINATION}/${FILE_NAME}"

echo ""
echo "Screengrabbing for ${DESTINATION}/${FILE_NAME} stopped at $(date +%T)"
