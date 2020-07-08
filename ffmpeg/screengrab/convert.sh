#!/usr/bin/env bash

# output file configuration
DESTINATION="/media/user/ffmpeg_capture"
TIME_LABEL="$(date +%F_%T_%s)"
FILE_NAME="${1}.mkv"

# I don't know what this does
PROBESIZE="25M"
# I don't know what this does
THREAD_QUEUE_SIZE="1024"

echo "Conversion started at $(date +%T)"

ffmpeg \
  -loglevel error \
  -i "$2" \
  -c:a flac \
  -c:v h264_nvenc \
  -profile high \
  -pix_fmt yuv420p \
  -crf 17 \
  -max_muxing_queue_size 99999 \
  "$DESTINATION/$FILE_NAME"

echo ""
echo "Conversion for $DESTINATION/$FILE_NAME stopped at $(date +%T)"
