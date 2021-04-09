#!/usr/bin/env bash

# e.g.
# ./scan.sh test_scan png JPEG 75

FILENAME="${1:-scan}"
FORMAT="${2:-"png"}"
COMPRESSION="${3:-"None"}"
RESOLUTION="${4:-75}"
DEVICE="${5:-"hpaio:/net/HP_Color_LaserJet_MFP_M476dw?ip=192.168.2.99"}"

START_TIME="$(date +%s)"

# @todo - see if the file name already exists on the hard drive
# FILENAME="${FILENAME}.${FORMAT}"

ARGUMENTS="--device-name=${DEVICE}"
ARGUMENTS="${ARGUMENTS} --resolution=${RESOLUTION}dpi"
ARGUMENTS="${ARGUMENTS} --format=${FORMAT}"
ARGUMENTS="${ARGUMENTS} --mode=Color"
ARGUMENTS="${ARGUMENTS} --source=Flatbed"
ARGUMENTS="${ARGUMENTS} --compression=${COMPRESSION}"
ARGUMENTS="${ARGUMENTS} -v"
ARGUMENTS="${ARGUMENTS} -p"
ARGUMENTS="${ARGUMENTS} > ${FILENAME}"

COMMAND="scanimage ${ARGUMENTS}"

echo "Running command:"
echo "${COMMAND}"

# @see - https://stackoverflow.com/questions/2005192/how-to-execute-a-bash-command-stored-as-a-string-with-quotes-and-asterisk
# @todo - this is a bad practice
eval "${COMMAND}"

echo "Command finished:"
echo "scanimage ${ARGUMENTS}"

FINISH_TIME="$(date +%s)"
SCAN_DURATION="$((FINISH_TIME-START_TIME))"

echo "Scan took ${SCAN_DURATION} seconds."


# scanimage -h
#
# Usage: scanimage [OPTION]...
#
# Start image acquisition on a scanner device and write image data to
# standard output.
#
# Parameters are separated by a blank from single-character options (e.g.
# -d epson) and by a "=" from multi-character options (e.g. --device-name=epson).
# -d, --device-name=DEVICE   use a given scanner device (e.g. hp:/dev/scanner)
#     --format=pnm|tiff|png|jpeg  file format of output file
# -i, --icc-profile=PROFILE  include this ICC profile into TIFF file
# -L, --list-devices         show available scanner devices
# -f, --formatted-device-list=FORMAT similar to -L, but the FORMAT of the output
#                            can be specified: %d (device name), %v (vendor),
#                            %m (model), %t (type), %i (index number), and
#                            %n (newline)
# -b, --batch[=FORMAT]       working in batch mode, FORMAT is `out%d.pnm' `out%d.tif'
#                            `out%d.png' or `out%d.jpg' by default depending on --format
#     --batch-start=#        page number to start naming files with
#     --batch-count=#        how many pages to scan in batch mode
#     --batch-increment=#    increase page number in filename by #
#     --batch-double         increment page number by two, same as
#                            --batch-increment=2
#     --batch-print          print image filenames to stdout
#     --batch-prompt         ask for pressing a key before scanning a page
#     --accept-md5-only      only accept authorization requests using md5
# -p, --progress             print progress messages
# -n, --dont-scan            only set options, don't actually scan
# -T, --test                 test backend thoroughly
# -A, --all-options          list all available backend options
# -h, --help                 display this help message and exit
# -v, --verbose              give even more status messages
# -B, --buffer-size=#        change input buffer size (in kB, default 32)
# -V, --version              print version information
#
# Options specific to device `hpaio:/net/HP_Color_LaserJet_MFP_M476dw?ip=192.168.1.99':
#   Scan mode:
#     --mode Lineart|Gray|Color [Lineart]
#         Selects the scan mode (e.g., lineart, monochrome, or color).
#     --resolution 75|100|150|200|300|600|1200dpi [75]
#         Sets the resolution of the scanned image.
#     --source Flatbed|ADF|Duplex [Flatbed]
#         Selects the scan source (such as a document-feeder).
#   Advanced:
#     --brightness -1000..1000 [0]
#         Controls the brightness of the acquired image.
#     --contrast -1000..1000 [0]
#         Controls the contrast of the acquired image.
#     --compression None|JPEG [JPEG]
#         Selects the scanner compression method for faster scans, possibly at
#         the expense of image quality.
#     --jpeg-quality 0..100 [inactive]
#         Sets the scanner JPEG compression factor. Larger numbers mean better
#         compression, and smaller numbers mean better image quality.
#   Geometry:
#     -l 0..215.9mm [0]
#         Top-left x position of scan area.
#     -t 0..296.926mm [0]
#         Top-left y position of scan area.
#     -x 0..215.9mm [215.9]
#         Width of scan-area.
#     -y 0..296.926mm [296.926]
#         Height of scan-area.
#
# Type ``scanimage --help -d DEVICE'' to get list of all options for DEVICE.
#
# List of available devices:
#     hpaio:/net/HP_Color_LaserJet_MFP_M476dw?ip=192.168.1.99

