
First, get the blackmagic decklink sdk:

https://www.blackmagicdesign.com/support/family/capture-and-playback

I think you have to register.  Once you download that, extract it.  The folder of interest (at the time of this writing) is `/Blackmagic DeckLink SDK 10.11.4/Linux/include/`.  This directory contains all of the stuff that is needed for ffmpeg to be compiled with the components necessary to capture HDMI video from the blackmagic intensity capture card.  I do not know how to capture the analog inputs with ffmpeg.

1. `sudo mkdir "/usr/include/blackmagic_decklink_sdk"`
1. `sudo cp -R ./Blackmagic\ DeckLink\ SDK\ 10.11.4/Linux/include/* "/usr/include/blackmagic_decklink_sdk/"`
1. `./compile_ffmpeg.sh`

Next, you will need to install the Blackmagic Drivers (thankfully, ffmpeg will output an error telling you that the drivers are missing).  Again, go to the support website to get the linux drivers for the capture and playback card.  The drivers are located in:

`/home/user/Downloads/Blackmagic_Desktop_Video_Linux_10.11.2/deb/x86_64/desktopvideo_10.11.2a3_amd64.deb`

