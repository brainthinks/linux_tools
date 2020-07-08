#!/usr/bin/env bash

DESTINATION="/media/user/intensity_capture"
FILE_NAME="$(date +%F-%s)_$1.mkv"

echo "Press q to quit recording..."

# @todo - have a param to output to /dev/null for the purposes of previewing
# or even better, figure out how to properly preview...

# @see - https://forum.blackmagicdesign.com/viewtopic.php?f=12&t=50941#p366997
# ffmpeg/ffmpeg -y -format_code Hp59 -f decklink -video_input hdmi -audio_input embedded -raw_format rgb10 -i 'Intensity Pro 4K' -acodec pcm_s16le -vcodec dnxhd -vf scale=1920x1080,fps=60000/1001,format=yuv422p10 -b:v 440M out.mov

./ffmpeg/ffmpeg \
  -format_code hp60 \
  -f decklink \
  -video_input hdmi \
  -audio_input embedded \
  -raw_format rgb10 \
  -i 'Intensity Pro 4K' \
  -c:a copy \
  -c:v libx264 \
  -preset ultrafast \
  -crf 17 \
  "$DESTINATION/$FILE_NAME"
