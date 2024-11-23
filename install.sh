#!/bin/bash
clear
echo ""
read -r -p "Please enter username for proot installation: " username </dev/tty

# Update and install packages
pkg update -y
pkg upgrade -y
pkg install x11-repo -y
pkg install termux-x11-nightly -y
pkg install pulseaudio -y
pkg install proot-distro -y
pkg install wget -y
pkg install git -y

# Display a message 
clear -x
echo ""
echo "Installing Termux-X11 APK" 
# Wait for a single character input 
echo ""
read -n 1 -s -r -p "Press any key to continue..."
wget https://github.com/termux/termux-x11/releases/download/nightly/app-universal-debug.apk
mv app-universal-debug.apk $HOME/storage/downloads/
termux-open $HOME/storage/downloads/app-universal-debug.apk

# Install Debian With proot-distro
proot-distro install debian

# Login Debian And Install Packages
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt update -y
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt upgrade -y
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt install sudo -y
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt install sudo nano adduser -y

# Add User and install XFCE4
pd login debian --shared-tmp -- env DISPLAY=:1.0 adduser "$username"
chmod u+rw $PREFIX/var/lib/proot-distro/installed-rootfs/debian/etc/sudoers
echo "$username ALL=(ALL:ALL) ALL" | tee -a $PREFIX/var/lib/proot-distro/installed-rootfs/debian/etc/sudoers > /dev/null
pd login debian --user "$username" -- env DISPLAY=:1.0 whoami
pd login debian --user "$username" -- env DISPLAY=:1.0 sudo whoami 
pd login debian --user "$username" -- env DISPLAY=:1.0 sudo apt install xfce4 -y

# Install script for execute XFCE4 and customise it
wget https://raw.githubusercontent.com/Mohameda332/auto-debian-install/refs/heads/main/startxfce4_debian.sh
chmod u+rw $PREFIX/data/data/com.termux/files/usr/bin/bash
chmod +x startxfce4_debian.sh
chmod u+rw $PREFIX/usr/etc/bash.bashrc
echo "alias start=./startxfce4_debian.sh" | tee -a $PREFIX/usr/etc/bash.bashrc > /dev/null
#Insall Pi-Apps & Firefox
pd login debian --user "$username" -- env DISPLAY=:1.0 wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
pd login debian --user "$username" -- env DISPLAY=:1.0 sudo apt install firefox-esr
echo "Restart Termux And Start XFCE4 with start command"
rm install.sh 
exit
