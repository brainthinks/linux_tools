import os
# import sys
import traceback

from FileIsDirectoryError import FileIsDirectoryError
from FileDoesNotExistError import FileDoesNotExistError
from FileOnFloppy import FileOnFloppy

class FilesOnFloppy:
  idx = 0
  source = None
  destination = None
  files = None
  fileList = None

  def __init__ (self, source, destination):
    print('Constructing FilesOnFloppy')
    self.idx = 0
    self.source = source
    self.destination = destination
    self.fileList = self.getFileList()
    print(len(self.fileList))

  def __iter__(self):
    return self

  # @see - https://stackoverflow.com/a/21665616
  def __next__(self):
    idx = self.idx
    print(len(self.fileList))

    try:
      print('getting file from list at position ' + str(idx))
      fileFromList = self.fileList[idx]
      self.idx += 1
      return fileFromList
    except IndexError:
      print('no more files in list')
      self.idx = 0
      raise StopIteration  # Done iterating.

  # @private
  #
  # @returns:
  #   String - the name of the file
  #   False  - there are no more files to be iterated
  #   None   - Unknown error
  def getNextFile(self, files):
    file = None

    try:
      print('Getting next file')
      file = files.__next__()
      print(file.path)
    except StopIteration:
      print('No more files to get')
      file = False
    except:
      print('Error while getting next file:')
      traceback.print_exc()
      # print(sys.exc_info()[0])
      file = None
    finally:
      return file

  # @private
  #
  # @returns:
  #   Iterator - an array of FileOnFloppy instances, each of which represents a
  #   file to be copied
  def getFileList(self, _source =None, _destination =None, _list =[]):
    if not _source:
      _source = self.source
    if not _destination:
      _destination = self.destination

    # @see - https://www.simplifiedpython.net/python-get-files-in-directory/
    # use `scandir` here rather than `listdir` to account for disks that are
    # partially corrupted.  use of `scandir` allows us to retrieve the files
    # that are still intact at the filesystem/os level.
    files = os.scandir(_source)

    file = None

    while file is not False:
      file = self.getNextFile(files)

      if file is False:
        print('Finished scanning floppy')
        break

      if file is None:
        print('Unknown error while scanning floppy printed above')
        continue

      fileOnFloppy = None

      try:
        print("  Trying to add file to list: ", file.name)
        fileOnFloppy = FileOnFloppy(file, _source, _destination)
        print('+ Found valid file: ', fileOnFloppy.target)
        _list.append(fileOnFloppy)
        print("+ Current number of valid files on floppy: ", len(_list))
      except FileIsDirectoryError as error:
        print("- Found directory: ", error.target)
        # @todo - if _list is ommitted here, it still works.
        # how is that possible?
        self.getFileList(error.target, error.destination, _list)
      except FileDoesNotExistError as error:
        print("** Found an invalid file or dir: ", error.target)
      except Exception as error:
        print("** ** Unknown error encountered while going through list of files:")
        traceback.print_exc()
        # print(sys.exc_info()[0])

    print('Returning list')
    print(len(_list))
    files.close()
    return _list
