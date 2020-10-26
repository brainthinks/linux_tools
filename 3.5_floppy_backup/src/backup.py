#!/usr/bin/env python3

import os
import shutil
import sys
import traceback
import time

from FilesOnFloppy import FilesOnFloppy

# Most of the scripts I write these days perform the operation in the cwd.
# However, in this case, I think having to `cd` in and out of a drive as it
# becomes mounted and unmounted would be too annoying.
DISK_PATH = sys.argv[1]
# Similarly, due to the semi-batch nature of my use case, which is backing up a
# stack of floppies as quickly as possible, having to `cd` in and out of the
# destination directory would be similarly annoying.
DESTINATION = sys.argv[2]

def copyAllFilesOnFloppy (successLog, errorLog):
  # Get an iterator for the floppy
  filesOnFloppy = FilesOnFloppy(DISK_PATH, DESTINATION)

  # iterate over them
  for fileOnFloppy in filesOnFloppy:
    try:
      # create the destination dir to mimic the directory structure of the
      # floppy
      if not os.path.exists(fileOnFloppy.destinationDir):
        os.makedirs(fileOnFloppy.destinationDir)

      print("About to copy " + fileOnFloppy.target)
      shutil.copy2(fileOnFloppy.target, fileOnFloppy.destination)

      successMessage = "Copied '" + fileOnFloppy.target + "' to '" + fileOnFloppy.destination
      print(successMessage)
      successLog.write(successMessage + "\n")
    except:
      traceback.print_exc()
      failureMessage = "Failed to copy '" + fileOnFloppy.target + "'!"
      print(failureMessage)
      errorLog.write(failureMessage + "\n")

def main ():
  startTime = time.time()

  # Create per-floppy log files
  successLog = open(DESTINATION + "/log.success.txt", 'w')
  errorLog = open(DESTINATION + "/log.error.txt", 'w')

  copyAllFilesOnFloppy(successLog, errorLog)

  endTime = time.time()

  totalTime = endTime - startTime
  timeMessage = "Total time: " + str(totalTime)
  print(timeMessage)
  successLog.write("\n" + timeMessage + "\n")

  errorLog.close()
  successLog.close()

# @todo - do that trick where main is only executed when the file is run as a
# script.
main()
