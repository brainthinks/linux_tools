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
    -i "$SOURCE/$1" \
    -an \
    -c:v mpeg2video \
    -qscale:v 5 \
    "$TARGET/$2.m2v"
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
  local SOURCE_FILE="$1"
  local START_TIME="$2"
  local RUN_TIME="$3"
  local TARGET_FILE="$4"

  echo $SOURCE_FILE
  echo $START_TIME
  echo $RUN_TIME
  echo $TARGET_FILE

  ffmpeg -y -i "$SOURCE/$SOURCE_FILE" -ss "$START_TIME" -t "$RUN_TIME" -vn -c:a flac "$TARGET/$TARGET_FILE.flac"
}

# @see - https://superuser.com/questions/579008/add-1-second-of-silence-to-audio-through-ffmpeg
# @see - https://trac.ffmpeg.org/wiki/Concatenate
function padFlac () {
  local SOURCE_FILE="$1"
  local PAD_TIME="$2"
  local RUN_TIME="$3"
  local SAMPLE_RATE="$4"
  local BIT_DEPTH="$5"
  local TARGET_FILE="$6"

  ffmpeg -y -f lavfi -i anullsrc=r="$SAMPLE_RATE" -t "$PAD_TIME" -sample_fmt "$BIT_DEPTH" "$TARGET/pad.flac"
  ffmpeg -y -i "$SOURCE/$SOURCE_FILE" -vn -c:a flac "$TARGET/temp1.flac"
  ffmpeg -y -i concat:"$TARGET/pad.flac|$TARGET/temp1.flac" -c flac "$TARGET/temp2.flac"
  ffmpeg -y -i "$TARGET/temp2.flac" -t "$RUN_TIME" -c flac "$TARGET/$TARGET_FILE.flac"
  rm "$TARGET/pad.flac" "$TARGET/temp1.flac" "$TARGET/temp2.flac"
}

# @todo - what was this used for?
function toAc3 () {
  ffmpeg -y \
    -i "$SOURCE/$1" \
    -vn \
    -c:a ac3 \
    "$TARGET/$2.ac3"
}
