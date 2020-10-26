#!/usr/bin/env bash

source "../utils.sh"

# @see - https://help.ubuntu.com/community/FireWire/dvgrab
# @see - http://renomath.org/video/linux/hi8/

DESTINATION="/media/user/linux_storage/backups/floppys"
TIMESTAMP="$(date +%F-%s)"
CUSTOM_LABEL="${1:-no_label}"

# On my installation of Linux Mint 19, with my particular floppy drive,
# the name of the mounted disk is literally "disk"
FLOPPY_PATH="${2:-/media/user/disk}"
DRIVE_PATH="${FLOPPY_PATH}"

FLOPPY_BACKUP_DIR="${TIMESTAMP}_${CUSTOM_LABEL}"

dps "About to backup a 3 1/2 floppy disk..."

# if [[ "$UID" -ne 0 ]]; then
#   dpe "You must run as root or with sudo."
#   exit 1
# fi

# @todo - check for the existence of destination!!!!

dps "Ensuring destination exists..."
mkdir -p "${DESTINATION}/${FLOPPY_BACKUP_DIR}"
ec "Created or confirmed ${DESTINATION}/${FLOPPY_BACKUP_DIR}" "Failed to create destination dir"

dps "Running backup script..."
./src/backup.py "${DRIVE_PATH}" "${DESTINATION}/${FLOPPY_BACKUP_DIR}"
ec "Successfully copied at least some files" "Critical error while copying files!"

dpsuc "Finished backing up floppy! '${FLOPPY_BACKUP_DIR}'"

exit 0
