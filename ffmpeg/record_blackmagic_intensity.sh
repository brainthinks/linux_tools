#!/usr/bin/env bash

DESTINATION="/media/user/linux_storage/videos/obs_recordings"
FILE_NAME="$(date +%F-%s).mkv"

echo "Press q to quit recording..."

# default ubuntu 18.04 flags
--toolchain=hardened 
--enable-gpl 
--disable-stripping 
--enable-avresample 
--enable-avisynth 
--enable-gnutls 
--enable-ladspa 
--enable-libass 
--enable-libbluray 
--enable-libbs2b 
--enable-libcaca 
--enable-libcdio 
--enable-libflite 
--enable-libfontconfig 
--enable-libfreetype 
--enable-libfribidi 
--enable-libgme 
--enable-libgsm 
--enable-libmp3lame 
--enable-libmysofa 
--enable-libopenjpeg 
--enable-libopenmpt 
--enable-libopus 
--enable-libpulse 
--enable-librubberband 
--enable-librsvg 
--enable-libshine 
--enable-libsnappy 
--enable-libsoxr 
--enable-libspeex 
--enable-libssh 
--enable-libtheora 
--enable-libtwolame 
--enable-libvorbis 
--enable-libvpx 
--enable-libwavpack 
--enable-libwebp 
--enable-libx265 
--enable-libxml2 
--enable-libxvid 
--enable-libzmq 
--enable-libzvbi 
--enable-omx 
--enable-openal 
--enable-opengl 
--enable-sdl2 
--enable-libdc1394 
--enable-libdrm 
--enable-libiec61883 
--enable-chromaprint 
--enable-frei0r 
--enable-libopencv 
--enable-libx264 
--enable-shared