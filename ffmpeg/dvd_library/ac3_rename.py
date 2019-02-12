from subprocess import call
import os

def getEnglishFileName(filenames, id):
  for filename in filenames:
    filename_parts = filename.split()
    if filename_parts[0] == id:
      return filename

for category in ["Hospital Housekeeping", "Custodial", "Floor Care", "Food Service", "General Safety"]:
  input_dir = "H:/SCETTF/Demuxed Masters/2015/" + category + "/AC3"
  # Go through each file in the AC3 folder
  english = []
  spanish = []
  for root, dirs, filenames in os.walk(input_dir):
    for filename in filenames:
      filename_parts = filename.split()
      if filename_parts[0] == "SPANISH":
        english_filename = getEnglishFileName(filenames, filename_parts[1])
        os.rename(input_dir + "/" + filename, input_dir + "/SPANISH  " + english_filename)
