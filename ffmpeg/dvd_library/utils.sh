#!/usr/bin/env bash

# @todo - null check for SOURCE and TARGET

# @todo - these currently have to be defined by the caller
# SOURCE
# TARGET

###
### Video
###

function toMkv () {
  local SOURCE="$1"
  local TARGET="$2"

  ffmpeg -y \
    -i "$SOURCE" \
    -an \
    -c:v copy \
    "$TARGET"
}

# The DVD video streams (VOB files) cannot (easily, at least)
# be losslessly placed into an MKV container.
function toMpeg () {
  ffmpeg -y \
    -i "$SOURCE/$1" \
    -an \
    -c:v copy \
    "$TARGET/$2.mpeg"
}

# @todo - what was this used for?
function toM2v () {
  ffmpeg -y \
    -analyzeduration 100M \
    -probesize 100M \
    -i "$SOURCE" \
    -an \
    -c:v mpeg2video \
    -qscale:v 5 \
    "$TARGET"
}

###
### Audio
###

# The DVD audio format that these VOBs contain is pcm_dvd, which cannot be
# stored in an MKA container.  I tried using the "pcm_s16le" codec, but I am not
# sure that it is lossless.
# @see - https://hydrogenaud.io/index.php/topic,83421.0.html
# @see - https://trac.ffmpeg.org/wiki/Seeking
# @see - http://snipplr.com/view/68795/ffmpeg--trim-audio-file-without-reencoding/
function toFlac () {
  local SOURCE="$1"
  local START_TIME="$2"
  local RUN_TIME="$3"
  local TARGET="$4"

  echo $SOURCE
  echo $START_TIME
  echo $RUN_TIME
  echo $TARGET

  ffmpeg -y \
    -i "$SOURCE" \
    -ss "$START_TIME" \
    -t "$RUN_TIME" \
    -vn \
    -c:a flac \
    "$TARGET"
}

function toFlacAsIs () {
  local SOURCE="$1"
  local TARGET="$2"

  ffmpeg -y \
    -i "$SOURCE" \
    -vn \
    -c:a flac \
    "$TARGET"
}

# @see:
# * https://superuser.com/questions/579008/add-1-second-of-silence-to-audio-through-ffmpeg
# * https://trac.ffmpeg.org/wiki/Concatenate
# * https://video.stackexchange.com/questions/16356/how-to-use-ffprobe-to-obtain-certain-information-about-mp4-h-264-files
# * https://trac.ffmpeg.org/wiki/FFprobeTips
function padFlacEnd () {
  local TARGET_RUN_TIME_FILE="$1"
  local SOURCE="$2"
  local TARGET="$3"

  if [ -z "${SOURCE}" ]; then
    echo "ERROR: source file is required"
    return 1
  fi

  if [ -z "${TARGET}" ]; then
    echo "ERROR: target file is required"
    return 1
  fi

  if [ -z "${TARGET_RUN_TIME_FILE}" ]; then
    echo "ERROR: file with target run time is required"
    return 1
  fi

  local TEMP_DIR="/tmp/dvd_library"

  mkdir -p "$TEMP_DIR"

  local TARGET_RUN_TIME="$(ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "${TARGET_RUN_TIME_FILE}")"
  local SOURCE_RUN_TIME="$(ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "${SOURCE}")"
  local SOURCE_SAMPLE_RATE="$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of default=noprint_wrappers=1:nokey=1 "${SOURCE}")"
  local SOURCE_SAMPLE_FMT="$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_fmt -of default=noprint_wrappers=1:nokey=1 "${SOURCE}")"
  local END_PAD_DURATION="$(echo "${TARGET_RUN_TIME} - ${SOURCE_RUN_TIME}" | bc)"

  if [ "${END_PAD_DURATION}" -eq "0" ]; then
    toFlacAsIs "${SOURCE}" "${TARGET}"
    echo "The durations are the same!"
    return 0
  fi

  # Generate the end pad flac file
  ffmpeg -y \
    -f lavfi \
    -i anullsrc=r="${SOURCE_SAMPLE_RATE}" \
    -t "${END_PAD_DURATION}" \
    -sample_fmt "${SOURCE_SAMPLE_FMT}" \
    "$TEMP_DIR/pad.flac"

  # Generate the flac file from the source
  toFlacAsIs "${SOURCE}" "$TEMP_DIR/temp1.flac"

  rm -f "${TEMP_DIR}/mylist.txt"
  touch "${TEMP_DIR}/mylist.txt"
  echo "file '${TEMP_DIR}/temp1.flac'" >> "${TEMP_DIR}/mylist.txt"
  echo "file '${TEMP_DIR}/pad.flac'" >> "${TEMP_DIR}/mylist.txt"

  # Concatenate the source flac file with the pad flac
  # NOTE - using the syntax `-i "concat:file1.flac|file2.flac"` resulted in errors
  # NOTE - the re-encode here is necessary to get the timestamps correct...
  ffmpeg -y \
    -safe 0 \
    -f concat \
    -i "${TEMP_DIR}/mylist.txt" \
    -c flac \
    "${TARGET}"

  echo "Target Run Time: ${TARGET_RUN_TIME}"
  echo "Actual Run Time: $(ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 ${TARGET})"

  return 0
}

# DEPRECATED
# @see - https://superuser.com/questions/579008/add-1-second-of-silence-to-audio-through-ffmpeg
# @see - https://trac.ffmpeg.org/wiki/Concatenate
function padFlac () {
  local SOURCE="$1"
  local PAD_TIME="$2"
  local RUN_TIME="$3"
  local SAMPLE_RATE="$4"
  local BIT_DEPTH="$5"
  local TARGET="$6"

  local TEMP_DIR="/tmp/dvd_library"

  mkdir -p "$TEMP_DIR"

  ffmpeg -y \
    -f lavfi \
    -i anullsrc=r="$SAMPLE_RATE" \
    -t "$PAD_TIME" \
    -sample_fmt "$BIT_DEPTH" \
    "$TEMP_DIR/pad.flac"

  ffmpeg -y \
    -i "$SOURCE" \
    -vn \
    -c:a flac \
    "$TEMP_DIR/temp1.flac"

  ffmpeg -y \
    -i concat:"$TEMP_DIR/pad.flac|$TEMP_DIR/temp1.flac" \
    -c flac \
    "$TEMP_DIR/temp2.flac"

  ffmpeg -y \
    -i "$TEMP_DIR/temp2.flac" \
    -t "$RUN_TIME" \
    -c flac \
    "$TARGET"

  rm -rf "$TEMP_DIR"
}

# @todo - what was this used for?
function toAc3 () {
  ffmpeg -y \
    -i "$SOURCE" \
    -vn \
    -c:a ac3 \
    "$TARGET"
}
