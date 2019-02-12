# Screengrabbing with FFMPEG

I have had trouble doing screen captures in the past, whether of me doing stuff on my desktop, playing Doom, playing League of Legends, or anything else I feel like recording.  Typically, the recording shows lines, seemingly randomly, that are of my desktop background.  I have refered to this as "tearing", but I'm not sure that that is the technically accurate term.  It seems like there are portions of the video where certain strips show my desktop background rather than what is actually visible to me on the computer screen.

I have recently wanted to be able to demonstrate some bugs in some software that I use, as well as record some tutorials for myself and others, and I have not come across what I think is a comprehensive, modern, and correct way to do screen capture on Linux.  I made a few videos in 2017 showing how I was doing it then, but I was never totally satisfied with the outcome - I got everything I wanted except for the fix to the screen tear.  It turns out that all I needed to do was enable triple buffering.  I was made aware of this by a generous comment on one of my youtube videos.

With the instructions from the videos I made in 2017 (linked below) and the knowledge I gained between then and now, from youtube comments and elsewhere, I wanted to put together a tutorial for doing proper and adequate screen capturing in the latest version of Mint/Ubuntu.

With these instructions and scripts, I can record my screen without tearing or compression/codec artifacts, with a track of my voice, the computer audio output, and a mix of the two.  This allows me to demonstrate something on the computer and voice over it if I want to.  After capturing the initial file (which is HUGE - you will need at least 100gb of hard drive space!), I can then convert the video to something smaller and more manageable, which I will then typically upload to youtube.

I hope you find this useful in some way.


## Goals

1. no screen tearing
1. no stuttering / dropped frames
1. no impact on performance of demonstration (e.g. Doom shouldn't run slow while I'm recording)
1. 1920x1080 resolution
1. 60 fps
1. computer audio track
1. voice-over audio track
1. converted files are high-quality (ffmpeg cfr 17)
1. converted files are of reasonable file size (~1.5gb per ten minutes)


## Configurations

### System

Note that I am using the following, and YMMV:
* Linux Mint 19
* Nvidia GeForce GTX 1080
* Nvidia drivers `410.48-ubuntu1`
* stock ubuntu ffmpeg

### Nvidia settings

These settings will reduce / eliminate screen tearing during screen capture.

1. Load "nvidia-settings"
1. Choose "X Server Display Configuration" from the left nav
1. Click "Save to X Configuration File"
1. Save the file to `/etc/X11/xorg.conf`
1. Quit the Nvidia Settings application
1. `sudo nano /etc/X11/xorg.conf`
1. Add the following line to `Section "Screen"`
    * `Option         "TripleBuffer" "On"`
1. Restart your computer

### AMD or Intel settings

You're on your own - I have an Nvidia card, and don't know what the appropriate settings are for other cards.


## Audio

Get the names of the audio sources from:

`pactl list sources | grep -i name:`


## Recording

See the `record.sh` file for what I use to record screen captures.  Replace the values of the variables as you see fit.


## Troubleshooting

1. Have you tried restarting your computer?
1. Can you record anything in OBS?
1. Can you record from all sources you care about in OBS?
1. Can you see your audio working in pavucontrol?

### Am I using X or Wayland?

Run `loginctl` to get your session ID - for me, it was `c2`

Run `loginctl show-session c2 -p Type`.  If you are using X, you'll see `x11`

If you're using Wayland, you're on your own.


# Resources

* [https://www.youtube.com/watch?v=W0rR6URTh24](https://www.youtube.com/watch?v=W0rR6URTh24)
    * an old video of mine for getting ffmpeg with nvenc to work in older versions of mint/ubuntu
* [https://www.youtube.com/watch?v=yDkOgjqN0NE](https://www.youtube.com/watch?v=yDkOgjqN0NE)
    * an old video of mine for getting ffmpeg to capture audio streams
* [https://unix.stackexchange.com/a/325972](https://unix.stackexchange.com/a/325972)
    * Determining X11 or Wayland
* [https://ubuntuforums.org/showthread.php?t=2392117](https://ubuntuforums.org/showthread.php?t=2392117)
    * Saving the nvidia settings to an xorg.conf file in Ubuntu 18.04
* [https://devtalk.nvidia.com/default/topic/823711/linux/tearing-add-frame-buffer-please/](https://devtalk.nvidia.com/default/topic/823711/linux/tearing-add-frame-buffer-please/)
    * Triple Buffer, which prevents screen tearing
* [https://www.linuxquestions.org/questions/linux-software-2/triple-buffer-on-nvidia-610335/](https://www.linuxquestions.org/questions/linux-software-2/triple-buffer-on-nvidia-610335/)
    * More Triple Buffer stuff
* [https://trac.ffmpeg.org/ticket/6375](https://trac.ffmpeg.org/ticket/6375)
    * Needed `max_muxing_queue_size` argument to make conversion script work


# @TODO

* conversion script
* use in-game gamma settings
* face in corner
* heart rate monitor
