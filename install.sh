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
pd login debian --shared-tmp -- env DISPLAY=:1.0 nano /etc/sudoers
pd login debian --user "$username" -- env DISPLAY=:1.0 whoami
pd login debian --user "$username" -- env DISPLAY=:1.0 sudo whoami 
pd login debian --user "$username" -- env DISPLAY=:1.0 sudo apt install xfce4 -y

# Install script for execute XFCE4 and customise it
wget https://raw.githubusercontent.com/LinuxDroidMaster/Termux-Desktops/main/scripts/proot_debian/startxfce4_debian.sh
nano startxfce4_debian.sh
#Change the user droidmaster with your username
#exit with ctrl+x and y
chmod +x startxfce4_debian.sh
cd ..
cd usr
cd etc
nano bash.bashrc
#add the command 'alias start=./startxfce4_debian.sh in the line after' 'fi'
cd && clear

#App Installer Utility .. For installing additional applications not available in Termux or Debian proot repositories. 
cat <<'EOF' > "$PREFIX/bin/app-installer"
#!/bin/bash

# Define the directory paths
INSTALLER_DIR="$HOME/.App-Installer"
REPO_URL="https://github.com/phoenixbyrd/App-Installer.git"
DESKTOP_DIR="$HOME/Desktop"
APP_DESKTOP_FILE="$DESKTOP_DIR/app-installer.desktop"

# Check if the directory already exists
if [ ! -d "$INSTALLER_DIR" ]; then
    # Directory doesn't exist, clone the repository
    git clone "$REPO_URL" "$INSTALLER_DIR"
    if [ $? -eq 0 ]; then
        echo "Repository cloned successfully."
    else
        echo "Failed to clone repository. Exiting."
        exit 1
    fi
else
    echo "Directory already exists. Skipping clone."
    "$INSTALLER_DIR/app-installer"
fi

# Check if the .desktop file exists
if [ ! -f "$APP_DESKTOP_FILE" ]; then
    # .desktop file doesn't exist, create it
    echo "[Desktop Entry]
    Version=1.0
    Type=Application
    Name=App Installer
    Comment=
    Exec=$PREFIX/bin/app-installer
    Icon=package-install
    Categories=System;
    Path=
    Terminal=false
    StartupNotify=false
" > "$APP_DESKTOP_FILE"
    chmod +x "$APP_DESKTOP_FILE"
fi

# Ensure the app-installer script is executable
chmod +x "$INSTALLER_DIR/app-installer"

EOF
chmod +x "$PREFIX/bin/app-installer"
bash $PREFIX/bin/app-installer

# Check if the .desktop file exists
if [ ! -f "$HOME/Desktop/app-installer.desktop" ]; then
# .desktop file doesn't exist, create it
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=App Installer
Comment=
Exec=$PREFIX/bin/app-installer
Icon=package-install
Categories=System;
Path=
Terminal=false
StartupNotify=false
" > "$HOME/Desktop/app-installer.desktop"
chmod +x "$HOME/Desktop/app-installer.desktop"
fi

echo "Start XFCE4 with the start command"
rm install.sh
