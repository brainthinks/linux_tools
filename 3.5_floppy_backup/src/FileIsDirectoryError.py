class FileIsDirectoryError(Exception):
  target = None
  destination = None

  def __init__(self, target, destination):
    self.target = target
    self.destination = destination
    super().__init__("Path {0} is a directory, not a file".format(self.target))
