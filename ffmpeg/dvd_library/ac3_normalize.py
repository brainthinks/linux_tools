# This script can be used to make two different ac3 files the same length using
# delaycut on windows:
#
# http://download.videohelp.com/jsoto/audiotools.htm
#

from subprocess import call
import shutil
import os

delaycut = "C:/Users/user/Downloads/delaycut_1212_exe/delaycut.exe"

class AC3:

  def __init__(self, file_name, file_path):
    # Declare the file-related properties
    self.file_path = file_path
    file_parts = file_name.split(".")
    self.extension = file_parts.pop()
    self.file_name = ".".join(file_parts)
    # Get the audio metadata properties
    self.getInfo()
    # Determine duration in milliseconds
    time_parts = self.duration.split(":")
    seconds_frames = time_parts.pop().split(".")
    self.milliseconds = int(seconds_frames[1]) + (int(seconds_frames[0]) * 1000) + (int(time_parts[1]) * 60 * 1000) + (int(time_parts[0]) * 60 * 60 * 1000)
    self.seconds = self.milliseconds/1000
    # Determine SPANISH counterpart file
    if os.path.isfile(file_path + "/SPANISH  " + file_name):
      self.spanish = AC3("SPANISH  " + file_name, file_path)

  def __str__(self):
    attrs = vars(self)
    return "\n".join("%s: %s" % item for item in attrs.items())

  # def isValid():
  #   return self.extension is "ac3" and not self.file_name.startswith("SPANISH")

  def getAbsPath(self):
    return self.file_path + "/" + self.file_name + "." + self.extension

  def getInfoFilePath(self):
    return self.file_path + "/" + self.file_name.lower() + "_log.txt"

  def getInfo(self):
    # Use delaycut to create the info file
    call([delaycut, "-info", self.getAbsPath()])
    # Attach every piece of information from the log to this object
    # Possible performance issues with this, but currently, this file currently
    # averages 1kb
    for metadata in open(self.getInfoFilePath()).read().split("\n"):
      prop = metadata.split("=")
      if len(prop) is not 2:
        continue
      setattr(self, prop[0].lower(), prop[1])
    # Delete the info file
    os.remove(self.getInfoFilePath())

  def normalize(self):
    # If there's no spanish version, there's nothing to do
    if not hasattr(self, "spanish"):
      print(self.file_name + " does not have a spanish track")
      return

    normalized_file = self.spanish.file_path + "/normalized " + self.spanish.file_name + "." + self.spanish.extension

    # If the audio files are the same length, copy the spanish track and rename it
    if self.milliseconds == self.spanish.milliseconds:
      print(self.file_name + " has an equally long spanish track")
      shutil.copy2(self.spanish.getAbsPath(), normalized_file)
      return

    # If the english version is larger, add silence to the spanish version
    if self.milliseconds > self.spanish.milliseconds:
      print(self.file_name + " is longer than the spanish version")
      call([delaycut, "-start", str(self.milliseconds - self.spanish.milliseconds), "-out", normalized_file, self.spanish.getAbsPath()])
      os.remove(self.spanish.getInfoFilePath())

    # If the spanish version is larger, truncate the end of the spanish version
    if self.milliseconds < self.spanish.milliseconds:
      print(self.file_name + " is shorter than the spanish version")
      call([delaycut, "-startsplit", "0", "-endsplit", str(self.seconds), "-out", normalized_file, self.spanish.getAbsPath()])
      os.remove(self.spanish.getInfoFilePath())


for category in [["Hospital Housekeeping", "HH"], ["Custodial", "CU"], ["Floor Care", "FC"], ["Food Service", "FS"], ["General Safety", "GS"]]:
  # Go through each file in the AC3 folder
  input_dir = "H:/SCETTF/Demuxed Masters/2015/" + category[0] + "/AC3"
  for root, dirs, filenames in os.walk(input_dir):
    for filename in filenames:
      # Only process AC3 files
      if not filename.endswith(".ac3"):
        continue

      # Don't process the SPANISH AC3 files directly, as they will be processed
      # as part of the normal flow for the English AC3 files
      if not filename.startswith(category[1]):
        continue

      # Create the AC3 object
      ac3 = AC3(filename, input_dir)
      ac3.normalize()
