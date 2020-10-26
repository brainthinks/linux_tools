#!/usr/bin/env bash

# @see - https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
# @see - http://trac.ffmpeg.org/wiki/HWAccelIntro
# @see - https://stackoverflow.com/questions/49825249/compiling-ffmpeg-with-an-output-device-decklink

set -e

ROOT_DIR="$(pwd)"
BUILD_DIR="${ROOT_DIR}/build"
BLACKMAGIC_SDK_PATH="/usr/include/blackmagic_decklink_sdk"
FFMPEG_SOURCE_URL="https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2"

BIN_DIR="${BUILD_DIR}/bin"
FFMPEG_BUILD_DIR="${BUILD_DIR}/ffmpeg_build"
FFMPEG_SOURCES_DIR="${BUILD_DIR}/ffmpeg_sources"

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
    libgnutls28-dev \
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
    yasm \
    zlib1g-dev \
    libx264-dev \
    libx265-dev \
    libnuma-dev \
    libvpx-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev
}

function prepareFileSystem () {
  rm -rf "${BUILD_DIR}"
  mkdir -p "${BIN_DIR}"
  mkdir -p "${FFMPEG_BUILD_DIR}"
  mkdir -p "${FFMPEG_SOURCES_DIR}"
}

function getFfmpegSource () {
  cd "${FFMPEG_SOURCES_DIR}"
  wget -O ffmpeg-snapshot.tar.bz2 "${FFMPEG_SOURCE_URL}"
  tar xjvf ffmpeg-snapshot.tar.bz2
}

function getNvencAssets () {
  git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
  cd nv-codec-headers
  make
  sudo make install
}

# @todo - check for the existence of `/usr/include/blackmagic_decklink_sdk`
function compileFfmpeg () {
  cd "${FFMPEG_SOURCES_DIR}/ffmpeg"

  PATH="${BIN_DIR}:${PATH}" \
  PKG_CONFIG_PATH="${FFMPEG_BUILD_DIR}/lib/pkgconfig" \
    ./configure \
      --prefix="${FFMPEG_BUILD_DIR}" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I${FFMPEG_BUILD_DIR}/include -I${BLACKMAGIC_SDK_PATH}" \
      --extra-ldflags="-L${FFMPEG_BUILD_DIR}/lib" \
      --extra-libs="-lpthread -lm" \
      --bindir="${BIN_DIR}" \
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
      --enable-nvenc \
      --enable-decklink

  # the -j20 flag refers to the number of cores to use for compiling
  PATH="${BIN_DIR}:${PATH}" \
    make \
      -j20

  make -j20 install
  hash -r
}

installDependencies
prepareFileSystem
getFfmpegSource
getNvencAssets
compileFfmpeg

echo "Next steps:"
echo "Ensure the NVIDIA proprietary driver is in use."
echo "Ensure the NVIDIA triple buffering is enabled."
