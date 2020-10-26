class FileDoesNotExistError(Exception):
  target = None

  def __init__(self, target):
    self.target = target
    super().__init__("Path {0} is invalid".format(self.target))
