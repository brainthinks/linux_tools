#!/usr/bin/env bash

################################################################################
# When I originally did all of my VHS captures, I really had no idea what I was
# doing.  Specifically, I read somewhere that the h.264 high 4:4:4 is "higher
# quality" or something, so I chose that as my encoder profile.  Turns out most
# players can't play h.264 profile "high", making the captures useless to my
# family members (and truthfully, myself - I hate being forced to use ffplay).
#
# So now, I am forced to convert them all to h.264 main.  Thankfully, I have an
# nvidia card with a hardware encoder, so it runs at around 5x on my core i3
# rig.
#
# This script will convert all mkv files in the current directory to mkv in the
# supplied target directory.  The conversion will use ffmpeg with nvenc, so be
# sure `ffmpeg` points to an ffmpeg instance that has hardware acceleration
# enabled.  The audio is converted to AAC to maximize compatibility with various
# devices and software.
#
# Note that you could use this for other purposes, but this script is
# specifically made to convert the files I captured from my blackmagic capture
# card with the high profile settings.  For instance, I also use this script to
# convert mkv files from DVDs rips (I use makemkv to get the mkv files) into
# mp4 files that I can play on a Roku.
#
# Also note that there is no concern about filesize here - the captured files
# are big.  I expect the output size of the files that are converted by this
# script to be about half as large as the source captured files, but it's not
# a concern for my use case.
#
# Usage:
#
# Convert all files in the current directory:
# `/path/to/convert_captures.sh /path/to/put/converted/mkvs/in`
################################################################################

# @see - https://www.turnkeylinux.org/blog/shell-error-handling
set -e

# multi-line command comment prefix - @see https://stackoverflow.com/a/33401168
REM=""

nl=$'\n'
final_message=""
already_converted=0
successful_conversions=0
failed_conversions=0

# The path that contains the files to convert
source_directory="$1"
# The directory in which to put the converted files
target_directory="$2"

if [ -z "${source_directory}" ]; then
  echo "You must provide a source directory, exiting"
  exit 1
fi

if [ ! -d "${source_directory}" ]; then
  echo "The source directory doesn't exist, exiting"
  exit 1
fi

if [ -z "${target_directory}" ]; then
  echo "You must provide a target directory, exiting"
  exit 1
fi

if [ ! -d "${target_directory}" ]; then
  echo "The target directory doesn't exist, exiting"
  exit 1
fi

# This is the extension of files we will convert
source_extension="mkv" # for vhs/dvd dumps
# source_extension="dv" # for dv dumps
# source_extension="m2ts" # for bluray dumps
# This is the extension we will use for the converted files
target_extension="mp4"

# Convert the high profile video to a main profile video that is suitable for
# multiple devices, not just lossless archiving.
# @see - https://superuser.com/a/1236387
function convert_with_gpu () {
  local source="$1"
  local target="$2"

  ffmpeg \
    -i "${source}" \
      ${REM# @see - https://stackoverflow.com/a/56681096 #} \
    -max_muxing_queue_size 9999 \
      ${REM# aac is a widely-supported audio format #} \
    -c:a aac \
      ${REM# based on some anecdotal testing, 192 is the best my ears can discerne #} \
    -b:a 192k \
      ${REM# use the hardware to do the encoding! #} \
    -c:v h264_nvenc \
      ${REM# chose vbr, probably not much difference from cbr given the target quality #} \
    -rc:v vbr_hq \
      ${REM# according to ffmpeg, crf 17 is good enough, so make it one better #} \
    -cq:v 16 \
      ${REM# based on some anecdotal testing, 12_000k bitrate prevents noticable artifacts #} \
    -b:v 12000k \
      ${REM# prevent the vbr from going to high, which would make the file size unnecessarily large #} \
    -maxrate:v 13000k \
      ${REM# the h.264 main profile is widely-supported #} \
    -profile:v main \
      ${REM# the yuv420p pixel format is widely-supported #} \
    -pix_fmt yuv420p \
    "${target}"
}

function convert_with_cpu () {
  local source="$1"
  local target="$2"

  ffmpeg \
    -i "${source}" \
      ${REM# @see - https://stackoverflow.com/a/56681096 #} \
    -max_muxing_queue_size 9999 \
      ${REM# aac is a widely-supported audio format #} \
    -c:a aac \
      ${REM# based on some anecdotal testing, 192 is the best my ears can discerne #} \
    -b:a 192k \
    -c:v libx264 \
      ${REM# chose vbr, probably not much difference from cbr given the target quality #} \
    -rc:v vbr_hq \
      ${REM# according to ffmpeg, crf 17 is good enough, so make it one better #} \
    -cq:v 16 \
      ${REM# based on some anecdotal testing, 12_000k bitrate prevents noticable artifacts #} \
    -b:v 12000k \
      ${REM# prevent the vbr from going to high, which would make the file size unnecessarily large #} \
    -maxrate:v 13000k \
      ${REM# the h.264 main profile is widely-supported #} \
    -profile:v main \
      ${REM# the yuv420p pixel format is widely-supported #} \
    -pix_fmt yuv420p \
    "${target}"
}

function main () {
  local current_source_directory="${1}"
  local previous_source_directory="${2}"
  local current_target_directory="${3}"

  if [ ! -d "${current_source_directory}" ]; then
    echo "Invalid current directory: ${current_source_directory}"
    return 1
  fi

  if [ ! -d "${previous_source_directory}" ]; then
    echo "Invalid previous directory: ${previous_source_directory}"
    return 1
  fi

  if [ ! -d "${current_target_directory}" ]; then
    echo "Invalid target directory: ${current_target_directory}"
    return 1
  fi

  for path_to_source_file in "${current_source_directory}/"*
  do
    # Recursively traverse directories
    if [ -d "${path_to_source_file}" ]; then
      echo "${path_to_source_file}"
      echo "${current_source_directory}"
      echo "${previous_source_directory}"
      echo "${current_target_directory}"
      target_subdirectory="${current_target_directory}${path_to_source_file/${current_source_directory}/""}"
      mkdir -p "${target_subdirectory}"
      echo "${target_subdirectory}"
      main "${path_to_source_file}" "${current_source_directory}" "${target_subdirectory}"
      continue
    fi

    # Skip anything that isn't a file
    if [ ! -f "${path_to_source_file}" ]; then
      continue
    fi

    # echo "skipping ${path_to_source_file}..."
    # continue

    # Get the name of the file without the path
    # @see - https://stackoverflow.com/questions/13570327/how-to-delete-a-substring-using-shell-script
    # file_name=$(echo "${path_to_source_file}" | sed -E "s/${path_to_search_escaped}//g")

    # @see - https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
    filename="$(basename -- "$path_to_source_file")"
    extension="${filename##*.}"
    file_name="${filename%.*}"

    # Skip any file that isn't an mkv
    if [ "${extension}" != "${source_extension}" ]; then
      continue
    fi

    path_to_converted_file="${current_target_directory}/${file_name}.${target_extension}"

    # skip files that have already been converted
    if [ -f "${path_to_converted_file}" ]; then
      current_message="Already converted ${path_to_source_file} to ${path_to_converted_file}"
      echo "${current_message}"
      final_message="${final_message}${nl}${current_message}"
      already_converted=$((already_converted + 1))
      continue
    fi

    convert_with_cpu "${path_to_source_file}" "${path_to_converted_file}"
    # convert_with_gpu "${path_to_source_file}" "${path_to_converted_file}"

    # @todo - this also needs to check the return code of the previous function
    # call.  The existence of the file isn't enough to determine success.
    if [ -f "${path_to_converted_file}" ]; then
      current_message="Successfully converted ${path_to_source_file} to ${path_to_converted_file}"
      echo "${current_message}"
      final_message="${final_message}${nl}${current_message}"
      successful_conversions=$((successful_conversions + 1))
    else
      current_message="Failed to convert ${path_to_source_file}"
      echo "${current_message}"
      final_message="${final_message}${nl}${current_message}"
      failed_conversions=$((failed_conversions + 1))
    fi
  done
}

main "${source_directory}" "${source_directory}" "${target_directory}"

echo -e "${final_message}"
echo ""
echo "Finished converting all files in ${source_directory}"
echo "Successfully converted ${successful_conversions} videos"
echo "Skipped ${already_converted} videos that were already converted"
echo "Failed to convert ${failed_conversions} videos"
