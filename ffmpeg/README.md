# FFMPEG

The stock version of ffmpeg that comes with Ubuntu typically does not have all of the flags / features that I want enabled.  Thankfully, `nvenc` is now enabled by default, and in Ubuntu 18.04, the majority of the features / codecs I want are already installed.

## Custom Build

I use a custom build for `ffmpeg` because I have a BlackMagic Intensity card, and I want to be able to capture from it using `ffmpeg` rather than the semi-unstable Media Express application that BlackMagic ships for video capture.

Note that you'll need to go to the blackmagic support site to download the SDK.  Once you download the SDK, extract it, and run the following commands:

```
sudo mkdir /usr/include/blackmagic_decklink_sdk
sudo cp -R ~/Downloads/Blackmagic\ DeckLink\ SDK\ 10.11.4/Linux/include/* /usr/include/blackmagic_decklink_sdk
```

Note that the `enable-nonfree` flag is required for `enable-decklink`

## Capture / Conversion Scripts

Once I have the custom build accessible, the scripts in this project allow me to capture my desktop (with audio) and capture old VHS tapes from my capture card.  Maybe I'll include a diagram of my setup here one day.


# References

* [https://stackoverflow.com/questions/49825249/compiling-ffmpeg-with-an-output-device-decklink#49889471](https://stackoverflow.com/questions/49825249/compiling-ffmpeg-with-an-output-device-decklink#49889471)
* [https://ffmpeg.zeranoe.com/forum/viewtopic.php?t=1126](https://ffmpeg.zeranoe.com/forum/viewtopic.php?t=1126)
* [http://www.smorgasbork.com/2016/09/13/building-ffmpeg-support-decklink-capture-quicksync-encoding-skylake-edition/](http://www.smorgasbork.com/2016/09/13/building-ffmpeg-support-decklink-capture-quicksync-encoding-skylake-edition/)
* [https://www.blackmagicdesign.com/support/](https://www.blackmagicdesign.com/support/)
* [https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu)
* [https://trac.ffmpeg.org/wiki/HWAccelIntro#NVENC](https://trac.ffmpeg.org/wiki/HWAccelIntro#NVENC)
* [https://ffmpeg.org/ffmpeg-devices.html#decklink](https://ffmpeg.org/ffmpeg-devices.html#decklink)
* [https://ffmpeg.org/ffmpeg-all.html#Audible-AAX](https://ffmpeg.org/ffmpeg-all.html#Audible-AAX)
* [https://trac.ffmpeg.org/wiki/Capture/Desktop](https://trac.ffmpeg.org/wiki/Capture/Desktop)