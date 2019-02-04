# FFMPEG with Nvidia NVENC hardware acceleration

This is USELESS information!  I spent countless hours and multiple days/weeks figuring out how to get this to work with my setup, only to find that this hardware-based encoding solution is LESS PERFORMANT than just using the stock ffmpeg build on ubuntu with libx264...  I couldn't bring myself to delete the results of my research though...  And who knows, maybe when I upgrade to Linux Mint 21 and everything stops working, maybe I'll find out that it was because I had some proprietary Nvidia thing installed...

Note that I am using the following, and YMMV:
* Linux Mint 19.1
* Nvidia drivers `410.48-ubuntu1`
* Nvidia Video Codec SDK `8.2.16`
* cuda 10 - `cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64`
* latest ffmpeg - `N-92989-g3242160`
* latest ffnvcodec

## Preparation

1. Be aware of the resource links at the bottom of this readme.  If you get stuck, refer to those, as those are the resources I used to come up with this guide
1. Ensure you have the latest nvidia proprietary drivers installed
    1. use `Driver Manager` to enable the proprietary nvidia drivers
    1. use `Update Manager` to ensure you have the latest drivers and nvidia tools


## Install cuda toolkit

1. [https://developer.nvidia.com/cuda-downloads](https://developer.nvidia.com/cuda-downloads)
1. Choose the following download options:
    1. Linux
    1. x86_64
    1. Ubuntu
    1. 18.04
    1. deb (local)
1. Download the deb file
1. Install the `.deb` file that you download
1. All that deb file does is give you access to the cuda installation packages - you still have to install them
1. Run the additional installation commands from the website, e.g.:
    1. `sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub`
    1. `sudo apt update`
    1. `sudo apt install cuda`


## Install Nvidia Video Codec SDK

1. [https://developer.nvidia.com/nvidia-video-codec-sdk](https://developer.nvidia.com/nvidia-video-codec-sdk)
1. Sign up for an account
1. Download the SDK
1. Extract that SDK file, and make a note of where that is (I just kept mine in my Downloads folder), because you'll need it later


## Restart Your Computer

Seriously, restart your computer now.


## Confirm Cuda works

Run `nvidia-smi`.  Does it work, or does it display an error?  If it works and shows you a nicely formatted table, then you may continue to the next step.  If an error is printed, meaning you don't see a table with some driver info, try restarting your machine.  If that doesn't work, you're on your own.


## Run the `compile.sh` script

This script will install the rest of the necessary dependencies and will actually build ffmpeg for you in the `build` directory.


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


## Test

Run the following command:

`./build/bin/ffmpeg -y -probesize 25M -framerate 60 -video_size 1920x1080 -thread_queue_size 1024 -f x11grab -i :0 -c:v h264_nvenc out.mkv`

to record a sample screen capture to ensure that the ffmpeg you just compiled works with the nvida nvenc encoder.

If that test works, see the `record.sh` file for a more advanced example.


## Troubleshooting

1. Have you tried restarting your computer?
1. Does `./build/bin/ffmpeg -codecs | grep -i cuvid` show any codec entries?  If not, try deleting your whole build folder and starting over.
1. `./build/bin/ffmpeg -h encoder=h264_nvenc` shows arguments that are compatible with the `nvenc` encoder.  Are you using them correctly?
1. Can you record anything in OBS?
1. Can you record from all sources you care about in OBS?
1. Can you see your audio working in pavucontrol?

### Am I using X or Wayland?

Run `loginctl` to get your session ID - for me, it was `c2`

Run `loginctl show-session c2 -p Type`.  If you are using X, you'll see `x11`


# Resources

* [https://www.gamingonlinux.com/articles/how-to-an-update-on-fixing-screen-tearing-on-linux-with-an-nvidia-gpu.8892](https://www.gamingonlinux.com/articles/how-to-an-update-on-fixing-screen-tearing-on-linux-with-an-nvidia-gpu.8892)
    * nvidia settings for reducing / eliminating screen tearing
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

# FFMPEG Compile Resources

* [https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu)
    * Official FFMPEG documentation for compiling on Mint and Ubuntu
* [https://trac.ffmpeg.org/wiki/HWAccelIntro#NVENC](https://trac.ffmpeg.org/wiki/HWAccelIntro#NVENC)
    * Official FFMPEG documentation for using NVENC with FFMPEG
* [https://developer.nvidia.com/ffmpeg](https://developer.nvidia.com/ffmpeg)
    * Official Nvidia page with some overview information
    * Contains some of the compile flags I used
* [https://developer.nvidia.com/cuda-downloads](https://developer.nvidia.com/cuda-downloads)
    * Download page for the cuda toolkit, which is needed for the video codec sdk
* [https://developer.nvidia.com/nvidia-video-codec-sdk](https://developer.nvidia.com/nvidia-video-codec-sdk)
    * Download page for the Video Codec SDK, which is needed to use hardware acceleration from FFMPEG
* [https://github.com/FFmpeg/nv-codec-headers](https://github.com/FFmpeg/nv-codec-headers)
    * Official repo for nv-codec-headers, which are needed for FFMPEG to use the nvidia and cuda stuff during compilation
* [https://devtalk.nvidia.com/default/topic/457664/nvcc-quot-no-command-39-nvcc-39-found-quot-/](https://devtalk.nvidia.com/default/topic/457664/nvcc-quot-no-command-39-nvcc-39-found-quot-/)
    * Helped me troubleshoot by informing me that cuda executables are not on the $PATH by default, and that I need to add them to the $PATH when compiling FFMPEG
* [https://github.com/tensorflow/tensorflow/issues/7653](https://github.com/tensorflow/tensorflow/issues/7653)
    * Helped me troubleshoot using `nvidia-smi`
* [https://stackoverflow.com/questions/43022843/nvidia-nvml-driver-library-version-mismatch](https://stackoverflow.com/questions/43022843/nvidia-nvml-driver-library-version-mismatch)
    * Helped me troubleshoot by informing me that after I install cuda, I may need to restart my computer

