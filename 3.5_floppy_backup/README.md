# 3.5 Floppy Backup Script

## Use `./backup.sh`

1. Open `Disks`
1. Plug in the USB Drive
    1. e.g. [https://smile.amazon.com/SABRENT-External-Floppy-Drive-SBT-UFDB/dp/B000ALM3RC](https://smile.amazon.com/SABRENT-External-Floppy-Drive-SBT-UFDB/dp/B000ALM3RC)
1. Make a note of the label / name of the floppy disk
1. Insert the floppy disk into the drive
1. Wait for the drive to stop making noise / doing stuff
   1. If the drive doesn't make any noise / read the disk a few seconds after inserting it, physically eject the disk, unplug the floppy drive from the computer, and try again
1. Click the `Play`-looking icon in `Disks` to mount the floppy drive
1. Wait for the drive to stop making noise / doing stuff
1. Run the backup script, using the label / name from the previous step as the first and only argument
    1. e.g. `./backup.sh 2002_05_12_mothers_day_06`
1. Wait
1. Be patient!
    1. if it's really taking way too long, ctrl+c until the script stops, then use the `ddrescue` method below
1. Wait for the script to finish - it will tell you when it's done
1. Wait for the drive to stop making noise / doing stuff
1. Review the log files if you wish - they're in the newly-created floppy backup directory
    1. `log.success.txt`
    1. `log.error.txt`
1. Once it's finished, and you're satisfied with the results, click the `Stop`-looking icon in `Disks` to unmount the floppy drive
1. Physically eject the floppy disk
1. Repeat for as many floppy disks as you have

## Use ddrescue

Note this is a WIP

Most of the files won't copy from the mounted directory, but if they can't be copied, which is most often due to the file names (and contents) being corrupt, do you really want to copy them anyway?  If you think you can salvaget them, they're there in the mounted dir...

1. If the floppy is mounted in `Disks`, unmount it
2. `sudo ddrescue -d /dev/sdd ~/floppy.img ~/floppy.logfile`
3. `mkdir ~/floppy`
4. `sudo mount -o loop,ro ~/floppy.img ~/floppy`
5. `./backup [floppy label or name] ~/floppy`
6. Delete the floppy img, logfile, and dir

### Can't mount because of superblock error

`testdisk` wasn't able to fix my problem, but maybe you'll have luck with it.
@see - [https://ubuntuforums.org/showthread.php?t=2103994](https://ubuntuforums.org/showthread.php?t=2103994)
@see - [https://www.cgsecurity.org/wiki/TestDisk](https://www.cgsecurity.org/wiki/TestDisk)

I also tried `ddrescue` (`sudo apt install gddrescue`), which also didn't fix my problem - I still couldn't mount the image that `ddrescue` produced.
@see - [https://www.technibble.com/guide-using-ddrescue-recover-data/](https://www.technibble.com/guide-using-ddrescue-recover-data/)

I also tried `dosfsck` (`sudo dosfsck -r -l -a -v /dev/sdd`) which still didn't fix my issue.
@see - [https://askubuntu.com/questions/147228/how-to-repair-a-corrupted-fat32-file-system](https://askubuntu.com/questions/147228/how-to-repair-a-corrupted-fat32-file-system)

At that point, I gave up with that particular floppy.  I still have the img file, but I have no idea what to do with it.

## References

* [https://softwareengineering.stackexchange.com/questions/112463/why-do-iterators-in-python-raise-an-exception](https://softwareengineering.stackexchange.com/questions/112463/why-do-iterators-in-python-raise-an-exception)
* [https://www.programiz.com/python-programming/user-defined-exception](https://www.programiz.com/python-programming/user-defined-exception)
* [https://stackoverflow.com/questions/21665485/how-to-make-a-custom-object-iterable](https://stackoverflow.com/questions/21665485/how-to-make-a-custom-object-iterable)
* [https://stackoverflow.com/questions/4142151/how-to-import-the-class-within-the-same-directory-or-sub-directory](https://stackoverflow.com/questions/4142151/how-to-import-the-class-within-the-same-directory-or-sub-directory)
* [https://realpython.com/instance-class-and-static-methods-demystified/](https://realpython.com/instance-class-and-static-methods-demystified/)
* [https://www.simplifiedpython.net/python-get-files-in-directory/](https://www.simplifiedpython.net/python-get-files-in-directory/)
* [https://stackoverflow.com/a/1483494](https://stackoverflow.com/a/1483494)
