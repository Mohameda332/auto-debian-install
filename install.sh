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
mv app-arm64-v8a-debug.apk $HOME/storage/downloads/
termux-open $HOME/storage/downloads/app-universal-debug.apk

# Install Debian With proot-distro
proot-distro install debian

# Login Debian And Install Packages
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt update -y
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt upgrade -y
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt install sudo -y
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt install sudo nano adduser -y

# Add User and install XFCE4
pd login debian --shared-tmp -- env DISPLAY=:1.0 adduser username
pd login debian --shared-tmp -- env DISPLAY=:1.0 nano /etc/sudoers
pd login debian --user speedlight -- env DISPLAY=:1.0 whoami
pd login debian --user speedlight -- env DISPLAY=:1.0 sudo whoami 
pd login debian --user speedlight -- env DISPLAY=:1.0 sudo apt install xfce4 -y

# Install script for execute XFCE4 and customise it
wget https://raw.githubusercontent.com/LinuxDroidMaster/Termux-Desktops/main/scripts/proot_debian/startxfce4_debian.sh
nano startxfce4_debian.sh
#Change the user droidmaster with your username
#exit with ctrl+x and y
chmod +x startxfce4_debian.sh
cd ..usr/etc
nano bash.bashrc
#add the command 'alias start=./startxfce4_debian.sh in the line after' 'fi'
cd
echo "Start XFCE4 with the start command"
rm install.sh
