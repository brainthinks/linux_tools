# Samba on Linux

## Mount Shared Folder from Windows

Using `gio` messed up my connection, to the point where I had to restart my machine to be able to talk to the Windows share again. Here is how I did it:

Get the IP address from the Windows box:

```bash
ipconfig
```

Then do this on the Linux box:

```bash
# confirm that smbClient is installed
sudo apt install smbclient

# confirm the connection by listing the shares on the Windows machine
smbclient -L //192.168.x.x

# make a not of the shared dir you want to mount. i don't know if you can mount just the IP address

# create a mount dir
sudo mkdir /mnt/windows-share

# mount the network share to that mount dir
sudo mount -t cifs -o username=serverUserName //192.168.x.x/share-dir /mnt/windows-share/
```

@see:
* [https://askubuntu.com/questions/1050460/how-to-mount-smb-share-on-ubuntu-18-04](https://askubuntu.com/questions/1050460/how-to-mount-smb-share-on-ubuntu-18-04)
* [https://askubuntu.com/questions/1265923/configuring-20-04-samba-for-smbv1](https://askubuntu.com/questions/1265923/configuring-20-04-samba-for-smbv1)
