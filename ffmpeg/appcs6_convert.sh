#!/usr/bin/env bash

################################################################################
# Convert all of the files in a directory to an `mp4` with `h264` encoded video.
# Resulting file will be importable by Adobe Premiere Pro CS6.
#
# Note that this script will attempt to convert ALL files it finds in a
# directory except itself and except files it has already converted, so I
# recommend using a dedicated directory that contains ONLY the video files to be
# converted.
#
# Usage:
#
# Convert all files in the current directory:
# `./convert.sh`
#
# Convert all files in the specified directory
# `./convert.sh /path/to/files_to_convert`
#
# Convert all files in the specified directory, and place them in a different
# directory
# `./convert.sh /path/to/files_to_convert /path/to/converted_files`
################################################################################

# @see - https://www.turnkeylinux.org/blog/shell-error-handling
set -e

# The path that contains the files to convert
source_directory="${1:-$(pwd)}"
# The directory in which to put the converted files
target_directory="${2:-${source_directory}}"
# The suffix to append to the name of the converted file
target_suffix="fixed"
# This is the extension we will use for the resulting files
target_extension="mp4"

nl=$'\n'
final_message=""
successful_conversions=0
failed_conversions=0

# Convert $1 to an APPCS6-compliant file.  Write file to $2
function appcs6_convert () {
  local source="$1"
  local target="$2"

  ffmpeg \
    -i "${source}" \
    -c:v libx264 \
    -preset ultrafast \
    -crf 17 \
    -c:a copy \
    "${target}"
}

for path_to_source_file in "${source_directory}/"*
do
  # Skip anything that isn't a file
  if [ ! -f "${path_to_source_file}" ]; then
    continue
  fi

  # @see - https://stackoverflow.com/questions/13570327/how-to-delete-a-substring-using-shell-script
  # Get the name of the file without the path
  # file_name=$(echo "${path_to_source_file}" | sed -E "s/${path_to_search_escaped}//g")

  # @see - https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
  filename="$(basename -- "$path_to_source_file")"
  extension="${filename##*.}"
  file_name="${filename%.*}"

  # Skip this script file
  if [ "${filename}" = "$(basename -- "$0")" ]; then
    continue
  fi

  # Skip converted files (which will probably have already been overwritten)
  if [ "${file_name##*.}" = "${target_suffix}" ]; then
    continue
  fi

  path_to_converted_file="${target_directory}/${file_name}.${target_suffix}.${target_extension}"
  appcs6_convert "${path_to_source_file}" "${path_to_converted_file}"

  # @todo - this also needs to check the return code of the previous function
  # call.  The existence of the file isn't enough to determine success.
  if [ -f "${path_to_converted_file}" ]; then
    final_message="${final_message}${nl}Successfully converted ${path_to_source_file} to ${path_to_converted_file}"
    successful_conversions=$((successful_conversions + 1))
  else
    final_message="${final_message}${nl}Failed to convert ${path_to_source_file}"
    failed_conversions=$((failed_conversions + 1))
  fi
done

echo "${final_message}"
echo ""
echo "Finished converting all files in ${source_directory}"
echo "Successfully converted ${successful_conversions} videos"
echo "Failed to convert ${failed_conversions} videos"
