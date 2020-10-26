#!/usr/bin/env bash

DESTINATION="/media/user/intensity_capture"
FILE_NAME="$(date +%F-%s)_$1.mkv"

FFMPEG_BIN="./build/bin/ffmpeg"

echo "Press q to quit recording..."

# @todo - have a param to output to /dev/null for the purposes of previewing
# or even better, figure out how to properly preview...

# @see - https://forum.blackmagicdesign.com/viewtopic.php?f=12&t=50941#p366997
# ./build/bin/ffmpeg -h encoder=h264_nvenc
# ./build/bin/ffmpeg -sources decklink

# @see - https://ffmpeg.org/ffmpeg-devices.html#decklink
# Based on the above documentation, I do not know what value to use for the
# `format_code` option, because list_formats doesn't appear to work...

"${FFMPEG_BIN}" \
  -f decklink \
  -video_input hdmi \
  -audio_input embedded \
  -i 'Intensity Pro 4K' \
  -c:a copy \
  -c:v h264_nvenc \
    ${REM# chose vbr, probably not much difference from cbr given the target quality #} \
  -rc:v vbr \
    ${REM# according to ffmpeg, crf 17 is good enough, so make it a little better #} \
  -cq:v 15 \
    ${REM# based on some anecdotal testing, 12_000k bitrate prevents noticable artifacts #} \
  -b:v 12000k \
  -maxrate:v 13000k \
    ${REM# the main h.264 profile is widely-supported #} \
  -profile:v main \
    ${REM# the yuv420p pixel format is widely-supported #} \
  -pix_fmt yuv420p \
  "$DESTINATION/$FILE_NAME"


  # -raw_format rgb10 \
  # -c:v libx264 \
  # -preset ultrafast \
  # -crf 17 \
