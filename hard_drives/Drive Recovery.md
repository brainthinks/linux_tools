# Drive Recovery <!-- omit in toc -->

I have a ~13 year old collection of hard drives from a RAID6 array that failed.  This document outlines how I went about recovering the data from those drives.

## Table of Contents <!-- omit in toc -->

- [Drive Recovery](#drive-recovery)
  - [Table of Contents](#table-of-contents)
  - [Required Reading](#required-reading)
  - [Approach](#approach)
  - [Image the Drives](#image-the-drives)
  - [Do Something with the Images](#do-something-with-the-images)

## Required Reading

1. [https://www.technibble.com/guide-using-ddrescue-recover-data/](https://www.technibble.com/guide-using-ddrescue-recover-data/)
1. [https://www.data-medics.com/forum/how-to-clone-a-hard-drive-with-bad-sectors-using-ddrescue-t133.html](https://www.data-medics.com/forum/how-to-clone-a-hard-drive-with-bad-sectors-using-ddrescue-t133.html)
1. [https://www.gnu.org/software/ddrescue/manual/ddrescue_manual.html](https://www.gnu.org/software/ddrescue/manual/ddrescue_manual.html)

## Approach

Image each individual drive onto a newer drive that you do not expect to fail.  The older the drive, the higher likelihood of failure compared to a newer drive.  Since the drives I want to recover are ~13 years old, they need to be backed-up / images ASAP onto a newer drive before hardware failure makes them unreadable.

## Image the Drives

1. Prep your Linux machine
    1. power the computer down
    1. ensure the destination drive is hooked up and has enough free space
    1. plug in the first drive you want to recover
    1. turn the computer on
1. Get the information of the drive you wish to recover, specifically the value of `PATH`, e.g. `/dev/sdb`
    1. On Linux Mint, I simply opened the `Disks` application
    1. or, `lsblk -o path,label,size,fstype,model`
1. Open a terminal and run the `ddrescue` command for a "first pass" to get as much data as possible while putting as little strain on the drive as possible
    1. `sudo ddrescue -d /path/to/drive/to/recover /path/to/destination/drive/recovered_drive_01.img /path/to/destination/drive/recovered_drive_01.logfile`
1. Hammer the drive as much as you want to try to recover the bad sectors
    1. `sudo ddrescue -d -R -A --retrim -r1000 /path/to/drive/to/recover /path/to/destination/drive/recovered_drive_01.img /path/to/destination/drive/recovered_drive_01.logfile`
    1. Note that I was unable to recover a single bad sector
1. When you are finished with the drive, repeat all of the above steps with the rest of the drives.

## Do Something with the Images

@todo - I have my drive images, but I have not yet decided what I am going to do with them.
