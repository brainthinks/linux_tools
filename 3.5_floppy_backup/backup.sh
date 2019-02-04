#!/usr/bin/env bash

source "../utils.sh"

# @see - https://help.ubuntu.com/community/FireWire/dvgrab
# @see - http://renomath.org/video/linux/hi8/

VIDEO_USER="user"
DESTINATION="/media/user/linux_storage/backups/floppys"
TIMESTAMP="$(date +%F-%s)"
CUSTOM_LABEL="$1"

# On my installation of Linux Mint 19, with my particular floppy drive,
# the name of the mounted disk is literally "disk"
DRIVE_NAME="$2"
DRIVE_PATH="/media/user/${DRIVE_NAME}"

FILE_NAME="${TIMESTAMP}_${CUSTOM_LABEL}"

dps "About to backup a 3 1/2 floppy disk..."

# if [[ "$UID" -ne 0 ]]; then
#   dpe "You must run as root or with sudo."
#   exit 1
# fi

# @todo - check for the existence of destination!!!!

dps "Ensuring destination exists..."
mkdir -p "$DESTINATION/$FILE_NAME"
ec "Created or confirmed $DESTINATION/$FILE_NAME" "Failed to create destination dir"

# dps "Copying all files"
# cp -R "$DRIVE_PATH/." "$DESTINATION/$FILE_NAME"
# ec "Successfully copied all files." "Failed to copy all files!"

./backup.py "$DRIVE_PATH" "$DESTINATION/$FILE_NAME"

dpsuc "Finished backing up floppy! '$FILE_NAME'"

exit 0
