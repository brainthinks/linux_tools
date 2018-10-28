#!/usr/bin/env bash

BUILD_DIR="./build"

function installDependencies () {
  sudo apt-get update
  sudo apt-get -y install \
    autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
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
    x11grab \
    yasm \
    libx264-dev \
    libx265-dev \
    libnuma-dev \
    libvpx-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev
}

function installManDocs () {
  echo "MANPATH_MAP $BUILD_DIR/bin $BUILD_DIR/ffmpeg_build/share/man" >> ~/.manpath
}

function compileFfmpeg () {
  local recommendedFlags=(\
    '--prefix="$BUILD_DIR/ffmpeg_build"' \
    '--pkg-config-flags="--static"' \
    '--extra-cflags="-I$BUILD_DIR/ffmpeg_build/include"' \
    '--extra-ldflags="-L$BUILD_DIR/ffmpeg_build/lib"' \
    '--extra-libs="-lpthread -lm"' \
    '--bindir="$BUILD_DIR/bin"' \
    '--enable-gpl' \
    '--enable-libaom' \
    '--enable-libass' \
    '--enable-libfdk-aac' \
    '--enable-libfreetype' \
    '--enable-libmp3lame' \
    '--enable-libopus' \
    '--enable-libvorbis' \
    '--enable-libvpx' \
    '--enable-libx264' \
    '--enable-libx265' \
    '--enable-nonfree' \
  )

  local defaultUbuntuCompileFlags=(\
    '--toolchain=hardened' \
    '--enable-gpl' \
    '--disable-stripping' \
    '--enable-avresample' \
    '--enable-avisynth' \
    '--enable-gnutls' \
    '--enable-ladspa' \
    '--enable-libass' \
    '--enable-libbluray' \
    '--enable-libbs2b' \
    '--enable-libcaca' \
    '--enable-libcdio' \
    '--enable-libflite' \
    '--enable-libfontconfig' \
    '--enable-libfreetype' \
    '--enable-libfribidi' \
    '--enable-libgme' \
    '--enable-libgsm' \
    '--enable-libmp3lame' \
    '--enable-libmysofa' \
    '--enable-libopenjpeg' \
    '--enable-libopenmpt' \
    '--enable-libopus' \
    '--enable-libpulse' \
    '--enable-librubberband' \
    '--enable-librsvg' \
    '--enable-libshine' \
    '--enable-libsnappy' \
    '--enable-libsoxr' \
    '--enable-libspeex' \
    '--enable-libssh' \
    '--enable-libtheora' \
    '--enable-libtwolame' \
    '--enable-libvorbis' \
    '--enable-libvpx' \
    '--enable-libwavpack' \
    '--enable-libwebp' \
    '--enable-libx265' \
    '--enable-libxml2' \
    '--enable-libxvid' \
    '--enable-libzmq' \
    '--enable-libzvbi' \
    '--enable-omx' \
    '--enable-openal' \
    '--enable-opengl' \
    '--enable-sdl2' \
    '--enable-libdc1394' \
    '--enable-libdrm' \
    '--enable-libiec61883' \
    '--enable-chromaprint' \
    '--enable-frei0r' \
    '--enable-libopencv' \
    '--enable-libx264' \
    '--enable-shared' \
  )

  local blackmagicFlags=(\
    '--enable-nonfree' \
    '--enable-decklink' \
  )

  echo "${defaultUbuntuCompileFlags[@]}"

  PATH="$BUILD_DIR/bin:$PATH" \
  PKG_CONFIG_PATH="$BUILD_DIR/ffmpeg_build/lib/pkgconfig" \
    ./configure \
    "${recommendedFlags[@]}" \
    "${defaultUbuntuCompileFlags[@]}" \
    "${blackmagicFlags[@]}"

  PATH="$BUILD_DIR/bin:$PATH" make

  # make install

  # hash -r
}

compileFfmpeg

echo "Next steps:"
echo "Ensure the NVIDIA proprietary driver is in use."
