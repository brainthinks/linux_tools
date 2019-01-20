#!/usr/bin/env bash

# For general Mint & Ubuntu compilation info:
# @see - https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

# For using NVidia hardware acceleration:
# @see - https://trac.ffmpeg.org/wiki/HWAccelIntro
# @see - https://developer.nvidia.com/ffmpeg

DESTINATION="$(pwd)/build"
PATH="/usr/local/cuda/bin:$DESTINATION/bin:$PATH"

mkdir -p "$DESTINATION"

sudo apt update

sudo apt -y install \
  git \
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
  libx264-dev \
  libx265-dev \
  libnuma-dev \
  libvpx-dev \
  libmp3lame-dev

mkdir -p "$DESTINATION/ffmpeg_sources" "$DESTINATION/bin"

cd "$DESTINATION"
git clone https://github.com/FFmpeg/nv-codec-headers.git
cd nv-codec-headers
sudo make install

cd "$DESTINATION/ffmpeg_sources"
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg

  # --extra-cflags="-I$DESTINATION/ffmpeg_build/include" \
  # --extra-ldflags="-L$DESTINATION/ffmpeg_build/lib" \
  # --extra-cflags="-I/usr/local/cuda/include"
  # --extra-ldflags="-L/usr/local/cuda/lib64"
PKG_CONFIG_PATH="$DESTINATION/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$DESTINATION/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I/home/user/Downloads/Video_Codec_SDK_8.2.16/Samples/NvCodec/NvEncoder -I/usr/local/cuda/include -I$DESTINATION/ffmpeg_build/include" \
  --extra-ldflags="-L/home/user/Downloads/Video_Codec_SDK_8.2.16/Samples/NvCodec/Lib/linux/stubs/x86_64 -L/usr/local/cuda/lib64 -L$DESTINATION/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$DESTINATION/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --enable-cuda-sdk \
  --enable-cuda \
  --enable-cuvid \
  --enable-nvenc \
  --enable-libnpp

make -j 10
make install
hash -r

echo "$DESTINATION/bin/ffmpeg -codecs | grep -i cuvid"
echo "$DESTINATION/bin/ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -f x11grab -i \"0.0+1920,0\" -vf scale_npp=1920:1072 -vcodec h264_nvenc output0.264 -vf scale_npp=1280:720 -vcodec h264_nvenc output1.264"
