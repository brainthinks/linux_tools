# Blackmagic Intensity and FFMPEG

## Download `Desktop Video 11.6 SDK`

Navigate to [https://www.blackmagicdesign.com/support/family/capture-and-playback](https://www.blackmagicdesign.com/support/family/capture-and-playback), then search for "Desktop Video".  Download `Desktop Video 11.6 SDK`.  You will have to fill out their contact form (as far as I know).

Once downloaded, extract the SDK.  The folder of interest (at the time of this writing) is `Blackmagic DeckLink SDK 11.6/Linux/include/`.  This directory contains all of the stuff that is needed for ffmpeg to be compiled with the components necessary to capture HDMI video from the blackmagic intensity capture card.  I do not know how to capture the analog inputs with ffmpeg.

1. `sudo mkdir "/usr/include/blackmagic_decklink_sdk"`
1. `sudo cp -R "./Blackmagic DeckLink SDK 11.6/Linux/include/"* "/usr/include/blackmagic_decklink_sdk/"`

## Download `Desktop Video 11.6`

Navigate to [https://www.blackmagicdesign.com/support/family/capture-and-playback](https://www.blackmagicdesign.com/support/family/capture-and-playback), then search for "Desktop Video".  Download `Desktop Video 11.6`, then extract it.

Install (double-click) the `deb` package, located at `Blackmagic_Desktop_Video_Linux_11.6/deb/x86_64/`.

## Compile FFMPEG

Because we are using a special capture card, we have to compile our own FFMPEG:

1. `./compile_ffmpeg.sh`

Note that if you have not installed the Blackmagic desktopvideo drivers, you may encounter the following error when you run `ffmpeg`:

```
[decklink @ 0x55a74b065a80] Could not create DeckLink iterator. Make sure you have DeckLink drivers 10.11.4 or newer installed.
Intensity Pro 4K: Generic error in an external library
```

Note that you must have the latest NVIDIA drivers >= `455.28` for the nvenc encoder to work.  If the latest drivers are not installed, you may encounter this error when running `ffmpeg`:

```
[h264_nvenc @ 0x55747eaba200] Driver does not support the required nvenc API version. Required: 11.0 Found: 10.0
[h264_nvenc @ 0x55747eaba200] The minimum required Nvidia driver for nvenc is 455.28 or newer
Error initializing output stream 0:0 -- Error while opening encoder for output stream #0:0 - maybe incorrect parameters such as bit_rate, rate, width or height
```

To install the latest NVIDIA drivers, I actually had to install the beta drivers, since 455 is apparently not stable yet.

After downloading the run file from NVIDIA's website and chmod'ing it, I had to run the following to get into an environment where the X server wasn't running:

```bash
sudo telinit 3
```

## References

* [https://www.blackmagicdesign.com/developer/product/capture-and-playback](https://www.blackmagicdesign.com/developer/product/capture-and-playback)
* [https://ffmpeg.org/ffmpeg-devices.html#decklink](https://ffmpeg.org/ffmpeg-devices.html#decklink)
