#!/usr/bin/env bash

# I assume that you run this script from the directory in which it exists

ROOT_DIR="$(pwd)"
BUILD_DIR="$ROOT_DIR/src/build"
FFMPEG_TAG="n4.0.2"

function installDependencies () {
  sudo apt-get update
  sudo apt-get -y install \
    autoconf \
    automake \
    build-essential \
    cmake \
    git \
    libass-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    pkg-config \
    texinfo \
    wget \
    zlib1g-dev \
    yasm \
    libx264-dev \
    libx265-dev \
    libnuma-dev \
    libvpx-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev
}

# @todo - check for the existence of `/usr/include/blackmagic_decklink_sdk`
function compileFfmpeg () {
  cd ~/ffmpeg_sources
  wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
  tar xjvf ffmpeg-snapshot.tar.bz2
  cd ffmpeg
  PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include -I/usr/include/blackmagic_decklink_sdk" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --bindir="$HOME/bin" \
    --enable-gpl \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree \
    --enable-decklink

  PATH="$HOME/bin:$PATH" make -j20
  make -j20 install
  hash -r
}

function installManDocs () {
  echo "MANPATH_MAP $BUILD_DIR/bin $BUILD_DIR/ffmpeg_build/share/man" >> ~/.manpath
}

installDependencies
compileFfmpeg
# installManDocs

echo "Next steps:"
echo "Ensure the NVIDIA proprietary driver is in use."
echo "Ensure the NVIDIA triple buffering is enabled."
