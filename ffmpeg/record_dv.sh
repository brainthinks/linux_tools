#!/usr/bin/env bash

source "../utils.sh"

# @see - https://help.ubuntu.com/community/FireWire/dvgrab
# @see - http://renomath.org/video/linux/hi8/

VIDEO_USER="user"
DESTINATION="/media/user/disk_images_2/intensity_capture/dvgrab/split"
FILE_NAME="$(date +%F-%s)"

SINGLE_SEGMENT=$FALSE
SPLIT=$FALSE

while :
do
  case "$1" in
    --single-segment)
      SINGLE_SEGMENT=$TRUE
      shift
      ;;
    --split)
      SPLIT=$TRUE
      shift
      ;;
    --) # End of all options
      shift
      break
      ;;
    -*)
      echo "Error: Unknown option: $1" >&2
      exit 1
      ;;
    *)  # No more options
      break
      ;;
  esac
done

dps "About to record DV..."

if [[ "$UID" -ne 0 ]]; then
  dpe "You must run as root or with sudo."
  exit 1
fi

dps "Ensuring destination exists..."
mkdir -p "$DESTINATION/$FILE_NAME"
ec "Destination exists" "Failed to create destination dir"

if [[ $SINGLE_SEGMENT = $TRUE ]]; then
  dps "Rewinding the tape, then recording single segment..."
  # Rewind the tape, then record the entire tape as a single file
  dvgrab \
    -format raw \
    -rewind \
    -t \
    -s 0 \
    "$DESTINATION/$FILE_NAME/single_segment_"
  ec "Finished recording single segment" "Failed to record single segment!"
fi

if [[ $SPLIT = $TRUE ]]; then
  dps "Rewinding the tape, then recording split segments..."
  # Rewind the tape, then record the entire tape, allowing dvgrab
  # to split the video into files based on breaks in the timecode
  dvgrab \
    -format raw \
    -rewind \
    -a \
    -t \
    -s 0 \
    "$DESTINATION/$FILE_NAME/segment_"
  ec "Finished recording split segments" "Failed to record split segments!"
fi

# Because we are required to run dvgrab as root, ensure that the
# resulting files are able to be modified by the user of your
# choice.
dps "Fixing permissions..."
chown -R "$VIDEO_USER":"$VIDEO_USER" "$DESTINATION"
ec "Fixed permissions" "Failed to fix permissions!"

dpsuc "Finished recording DV! '$FILE_NAME'"

# @todo - When we're finished recording, rewind the tape
exit 0
