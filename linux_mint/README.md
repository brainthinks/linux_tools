# Linux Mint

## Create Bootable USB

Ripped straight from [https://community.linuxmint.com/tutorial/view/744](https://community.linuxmint.com/tutorial/view/744):

`sudo dd if=~/Desktop/linuxmint.iso of=/dev/sdx oflag=direct bs=1048576`

## Date / Time Format

`%A, %B %d    %Y-%m-%d    %H:%M %p`

## Check Version

Check Linux Mint version:

`cat /etc/linuxmint/info`
`cat /etc/os-release`

Check Ubuntu version:

`cat /etc/upstream-release/lsb-release`

```bash
# Get the ubuntu release name, usually gotten via `lsb_release -sc`, for linux mint:
# https://stackoverflow.com/questions/15148796/bash-get-string-after-character

grep "UBUNTU_CODENAME" /etc/os-release | sed -e 's#.*=\(\)#\1#'
```

Check Debian version:

`cat /etc/debian_version`

Check architecture (32-bit vs 64-bit)

`uname -m`

i686 == 32-bit
x86_64 == 64-bit

## Launchers

Aka application launchers, desktop shortcuts, the icons in the panel... etc.

Directory that houses the launchers that exist for all users of the system:

`/usr/share/applications/`

Directory that houses the launchers that exist for the currently logged in user:

`~/.local/share/applications/`

Create a new launcher:

`gnome-desktop-item-edit ~/.local/share/applications --create-new`
