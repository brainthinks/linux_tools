#!/usr/bin/env bash

# output file configuration
DESTINATION="/media/user/linux_storage/videos/obs_recordings"
TIME_LABEL="$(date +%F_%T_%s)"
FILE_NAME="${TIME_LABEL}.mkv"

# I don't know what this does
PROBESIZE="25M"
# I don't know what this does
THREAD_QUEUE_SIZE="1024"

echo "Conversion started at $(date +%T)"

ffmpeg \
  -y \
  -loglevel error \
  -i "$1" \
  -c:a copy \
  -c:v libx264 \
  -crf 17 \
  -max_muxing_queue_size 99999 \
  "$DESTINATION/$FILE_NAME"

echo ""
echo "Conversion for $DESTINATION/$FILE_NAME stopped at $(date +%T)"
