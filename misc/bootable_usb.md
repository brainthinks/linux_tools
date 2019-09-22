# How to create a bootable usb from a bootable iso in linux

## Instructions

1. plug in your usb drive
1. unmount the usb drive
    1. you will need to use a utility such as ```lsblk``` to determine the mount point of your usb drive
    1. unmount the usb drive - ```umount /media/user/pathtoyourdrive```
    1. confirm the drive assignment (```/dev/sdXXX```) using ```lsblk``` again, and confirm it has no value under ```MOUNTPOINT```
1. ```dd bs=4M if=/path/to/file.iso of=/dev/sdXXX && sync```
    1. ```sdXXX``` should NOT contain the partition number, so use something like ```/dev/sdg``` rather than ```/dev/sdg1```
    1. ```sync``` will ensure that the data has completely finished writing to the usb drive
1. Process complete - once sync finishes running, you may pull the usb drive

## Interactive tools

### Unmount

<label for="mountPath">What is the mounted path to your usb stick?</label>
<input
  type="text"
  id="mountPath"
  name="mountPath"
  placeholder="/media/user/mydrive"
  onkeyup="onChangeMountPath(this.value, this)"
/>

<label for="umountCommand">This is your unmount command:</label>
<input
  type="text"
  id="umountCommand"
  name="umountCommand"
  readonly
/>

### Create USB

<label for="usbPath">What is the drive path to your usb stick (from lsblk)?</label>
<input
  type="text"
  id="usbPath"
  name="usbPath"
  placeholder="/dev/sdx"
  onkeyup="updateDdCommand()"
/>

<label for="isoPath">What is the path to your iso file?</label>
<input
  type="text"
  id="isoPath"
  name="isoPath"
  placeholder="~/isos/linux.iso"
  onkeyup="updateDdCommand()"
/>

<label for="ddCommand">This is your transfer command:</label>
<input
  type="text"
  id="ddCommand"
  name="ddCommand"
  readonly
/>

## Sources:

* [https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_dd](https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_dd)
* [http://www.thegeekstuff.com/2013/01/mount-umount-examples/](http://www.thegeekstuff.com/2013/01/mount-umount-examples/)
* [http://man7.org/linux/man-pages/man1/dd.1.html](http://man7.org/linux/man-pages/man1/dd.1.html)
* [http://man7.org/linux/man-pages/man1/sync.1.html](http://man7.org/linux/man-pages/man1/sync.1.html)
* [http://man7.org/linux/man-pages/man8/lsblk.8.html](http://man7.org/linux/man-pages/man8/lsblk.8.html)
* [http://man7.org/linux/man-pages/man2/umount2.2.html](http://man7.org/linux/man-pages/man2/umount2.2.html)

<script async type="text/javascript">
  function onChangeMountPath (value, element) {
    var umountCommandElement = document.getElementById('umountCommand');

    if (value) {
      umountCommandElement.value = 'umount ' + value;
    } else {
      umountCommandElement.value = '';
    }
  }

  function updateDdCommand () {
    var usbPath = document.getElementById('usbPath').value;
    var isoPath = document.getElementById('isoPath').value;

    var ddCommandElement = document.getElementById('ddCommand');

    if (usbPath && isoPath) {
      ddCommandElement.value = 'sudo dd bs=4M if="' + isoPath + '" of="' + usbPath + '" status=progress && sync';
    } else {
      ddCommandElement.value = '';
    }
  }
</script>