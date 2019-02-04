#!/usr/bin/env python3

import os
import shutil
import sys
import time

startTime = time.time()

def generateFileList(sourcePath, destinationPath, list):
  files = os.listdir(sourcePath);

  for filename in files:
    target = sourcePath + "/" + filename
    destination = destinationPath + "/" + filename

    if os.path.isfile(target):
      list.append([target, destination, destinationPath])
    elif os.path.isdir(target):
      list.extend(generateFileList(target, destination, list))

  return list

DISK_PATH = sys.argv[1]
DESTINATION = sys.argv[2]

successLog = open(DESTINATION + "/log.success.txt", 'w')
errorLog = open(DESTINATION + "/log.error.txt", 'w')

list = []

newList = generateFileList(DISK_PATH, DESTINATION, list)

for pair in newList:
  target = pair[0]
  destination = pair[1]
  destinationDirectory = pair[2]

  try:
    if not os.path.exists(destinationDirectory):
      os.makedirs(destinationDirectory)

    shutil.copy2(target, destination)

    successMessage = "Copied '" + target + "' to '" + destination
    # print(successMessage)
    successLog.write(successMessage + "\n")
  except:
    failureMessage = "Failed to copy '" + target + "'!"
    print(failureMessage)
    errorLog.write(failureMessage + "\n")

endTime = time.time()
totalTime = endTime - startTime
timeMessage = "Total time: " + str(totalTime)

print(timeMessage)

successLog.write("\n" + timeMessage + "\n")

errorLog.close()
successLog.close()
