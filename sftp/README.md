# Personal SFTP Server

Note: this was adapted from the excellent tutorial at [https://askubuntu.com/a/420679](https://askubuntu.com/a/420679)

1 - create a user in linux, preferably with a "standard" home folder
2 - set a static ip address
3 - configure a port forward in your router
4 - set up openssh-server

The best resource to help you begin setting up an ssh service on a Host machine using Ubuntu is OpenSSH Server. This will allow you to use SSH File Transfer Protocol (also Secure File Transfer Protocol, or SFTP) to access, transfer, and manage files over SSH from a Client machine.
Overview of Solution

    On Ubuntu you can setup an OpenSSH server on a Host machine and a user can then use ssh to connect from Client to Host's server using only a username and password. Note, however, that public key authentication is recommended,

    "Make sure you have a strong password before installing an SSH server (you may want to disable passwords altogether)"

    Administrative User Accounts created on Host will have sudo privileges, Standard User Accounts created on Host will not.

Install and configure your OpenSSH Server on Host

To install an OpenSSH server on Host:

sudo apt-get install openssh-server

Give your Host a Static IP address so you can reliably connect to it:

nm-connection-editor

To configure your OpenSSH server, "first, make a backup of your sshd_config file by copying it to your home directory, or by making a read-only copy in /etc/ssh by doing:"

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
sudo chmod a-w /etc/ssh/sshd_config.factory-defaults

"Once you've backed up your sshd_config file, you can make changes with any text editor, for example:"

sudo -H gedit /etc/ssh/sshd_config

You must restart your ssh service on Host for these changes to take effect

sudo service ssh restart

Consider the Following Security Measures

    Don't enable port-forwarding on your router: When outsider asks your router to connect outsider to Port 22, etc., your router fails to comply unless you have enabled port-forwarding
    Disable root login: Comment out PermitRootLogin without-password; add PermitRootLogin no to Host's /etc/ssh/sshd_config
    Choose non-standard SSH port: Comment out Port 22; add Port <new-port-number> to Host's /etc/ssh/sshd_config
    Allow only local connections: Add ListenAddress 192.168.0.10
    Allow certain users on certain ports: Add AllowUsers <username>@<IP_address_1> <username>@<IP_address_2> or AllowUsers <username>@111.222.333.* to Host's /etc/ssh/sshd_config
    Allow only RSA key (passwordless) connections: Append the contents of ~/.ssh/id_rsa.pub from each Client as a new line of Host's ~/.ssh/authorized_keys. Then add PasswordAuthentication no to to Host's /etc/ssh/sshd_config
    Slow attackers' cracking attempts: Use ufw (uncomplicated firewall) on Host to rate limit incoming connections to 10/minute: sudo apt-get install ufw && sudo ufw limit OpenSSH
    For more ideas, see Keeping SSH Access Secure

If you feel you must, Enable PasswordAuthentication in your sshd_config file

Find the line with the phrase PasswordAuthentication and make it read:

PasswordAuthentication yes

Save your new sshd_config file and then restart Host's ssh service:

sudo service ssh restart

If you need access from anywhere over the internet, Setup Port Forwarding on your local router to direct traffic to your OpenSSH server

Note the port Host's ssh service listens to in the sshd_config file and setup your router to forward TCP/UDP traffic aimed at this port to the IP address of your OpenSSH server.

    Typically, you can point your web browser to 192.168.1.1 in order to login to your router and setup port forwarding. See Configure OpenSSH server and router to accept SSH connection over internet?

Connect to Host and login via command-line or terminal

    To open an SFTP shell terminal as <username> on Host, open a Terminal on Client and enter the following command, replacing 123.123.1.23 with Host's IP address:

    sftp <username>@123.123.1.23

        If you changed the port number Host's OpenSSH server listens to, do:

        sftp -P <port_number_in_Host's_sshd_config_file> <username>@123.123.1.23

    To open an SSH shell terminal as <username> on Host, open a Terminal on Client and enter the following command, replacing 123.123.1.23 with Host's IP address:

    ssh <username>@123.123.1.23

        If you changed the port number Host's OpenSSH server listens to, do:

        ssh -p <port_number_in_Host's_sshd_config_file> <username>@123.123.1.23

Connect to Host and login via GUI file manager (e.g., Nautilus) for more visual SFTP access to enable file transfers

    Open Nautilus on Client
    Select File > Connect to Server
    Type: SSH
    Server: Enter Host's IP address
    Port: port number specified in Host's sshd_config file
    User name: username
    Password: password

enter image description here

In 14.04:

    Open Nautilus on Client
    Connect to Server
    Type: `ssh @123.123.1.23:

Create Standard User Accounts on Host with limited file permissions outside their home folder

Proper file permissions in place on Host guarantee that each standard user (without sudo privileges) that you create on Host will own their /home/new_user directory but have limited permissions with the rest of the directory structure.

    Limited permissions does not necessarily mean they are unable to view filenames and directory structure.

Hope that's helpful!
