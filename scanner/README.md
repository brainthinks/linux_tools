# Scanning over the network

Use the files in this directory to scan over the network using my HP all in one.

## Batch Scanning

1. `yarn`
1. `./scan.js [path/to/scan/destination]`
1. follow the prompts in the terminal

## Manual Scanning

`sudo apt install xsane* hplip*`
Add the printer via the Printers applet
Open the HP toolbox
select the printer
select scan
proceed with the scan
follow the prompts to install the plugin (it takes a while to download)

## Notes

The first time the script is run, it will prompt you to download some HP driver plugin or something.

The files it downloads can be found in `/home/user/.hplip`

Here are some of the processes that it appears to run:

```
sh -c hp-diagnose_plugin
/usr/bin/python3 /usr/bin/hp-diagnose_plugin
/usr/bin/python3 /usr/bin/hp-pkservice
sh -c hp-plugin -u --required --reason 0
/usr/bin/python3 /usr/bin/hp-plugin -u --required --reason 0
gpg-agent --homedir /home/user/.hplip/.gnupg --use-standard-socket --daemon
sh -c sh /home/user/.hplip/hplip-3.20.3-plugin.run --keep --nox11 -- -u /usr/bin/python3
sh /home/user/.hplip/hplip-3.20.3-plugin.run --keep --nox11 -- -u /usr/bin/python3
/bin/bash ./hplip-plugin-install -v 3.20.3 -c 64 -u /usr/bin/python3
```


## @TODOs

1. the scan process doesn't fail...  the script will think it's running normally even if the printer isn't turned on...

## References

* [https://help.ubuntu.com/community/sane](https://help.ubuntu.com/community/sane)
* [https://developers.hp.com/hp-linux-imaging-and-printing/binary_plugin.html](https://developers.hp.com/hp-linux-imaging-and-printing/binary_plugin.html)
* [https://linux.die.net/man/1/scanimage](https://linux.die.net/man/1/scanimage)

