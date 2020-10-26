import os
import sys

from FileIsDirectoryError import FileIsDirectoryError
from FileDoesNotExistError import FileDoesNotExistError

class FileOnFloppy:
  file = None
  sourceDir = None
  destinationDir = None
  fileName = None
  target = None
  destination = None

  @staticmethod
  def fileNameAsSafeString(file):
    # @see - https://www.simplifiedpython.net/python-get-files-in-directory/
    # @see - https://stackoverflow.com/questions/24947092/codec-cant-encode-character-character-maps-to-undefined
    safeString = file.name.encode(sys.stdout.encoding, errors='replace').decode('UTF-8')
    return safeString

  def __init__(self, file, sourceDir, destinationDir):
    self.file = file
    self.sourceDir = sourceDir
    self.destinationDir = destinationDir
    self.fileName = self.__class__.fileNameAsSafeString(self.file)
    self.target = os.path.join(self.sourceDir, self.fileName)
    self.destination = os.path.join(self.destinationDir, self.fileName)

    if os.path.isfile(self.target):
      return

    if os.path.isdir(self.target):
      raise FileIsDirectoryError(self.target, self.destination)

    # For whatever reason, likely corruption of the floppy disk, we cannot get
    # the file or dir
    raise FileDoesNotExistError(self.target)
