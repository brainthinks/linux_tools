#!/usr/bin/env bash

# @see - https://help.ubuntu.com/community/FireWire/dvgrab
# @see - http://renomath.org/video/linux/hi8/

VIDEO_USER="user"

DESTINATION="/media/user/disk_images_2/intensity_capture/dvgrab/split"
FILE_NAME="$(date +%F-%s)"

if [[ "$UID" -ne 0 ]]; then
  echo "You must run as root or with sudo."
  exit 1
fi

mkdir -p "$DESTINATION/$FILE_NAME"

# Rewind the tape, then record the entire tape as a single file
dvgrab \
  -format raw \
  -rewind \
  -t \
  -s 0 \
  "$DESTINATION/$FILE_NAME/single_segment_"

# Rewind the tape, then record the entire tape, allowing dvgrab
# to split the video into files based on breaks in the timecode
dvgrab \
  -format raw \
  -rewind \
  -a \
  -t \
  -s 0 \
  "$DESTINATION/$FILE_NAME/segment_"

# Because we are required to run dvgrab as root, ensure that the
# resulting files are able to be modified by the user of your
# choice.
chown -R "$VIDEO_USER":"$VIDEO_USER" "$DESTINATION"

# @todo - When we're finished recording, rewind the tape
exit 0
