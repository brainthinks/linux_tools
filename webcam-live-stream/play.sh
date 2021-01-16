#!/usr/bin/env bash

source ".env"

URL="rtsp://${RTSP_HOST}:${RTSP_PORT}/${STREAM_NAME}"

ffplay "${URL}"
