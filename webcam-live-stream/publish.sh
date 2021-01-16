#!/usr/bin/env bash

source ".env"

# @todo
# This url, which is the url that ffmpeg will publish the stream to, is the
# exact same url that is used by a client program to play the live video.  This
# means that the url that is being published to and the url that is being
# requested are exactly the same.  How does the rtsp server "intercept" the
# traffic first?  Is that always guaranteed?  Can I publish to a different url?
URL="rtsp://${RTSP_HOST}:${RTSP_PORT}/${STREAM_NAME}"

ffmpeg \
  -i /dev/video0 \
  -c:v h264_nvenc \
  -profile:v main \
  -pix_fmt yuv420p \
  -f rtsp "${URL}"
