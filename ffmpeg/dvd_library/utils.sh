#!/usr/bin/env bash

# @todo - null check for SOURCE and TARGET

# @todo - these currently have to be defined by the caller
# SOURCE
# TARGET

###
### Video
###

function toMkv () {
  ffmpeg -y \
    -i "$SOURCE/$1" \
    -an \
    -c:v copy \
    "$TARGET/$2.mkv"
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
