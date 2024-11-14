This is a script that you can use to install debian on android.
It use proot distro,termux,termux x11 and the desktop start script from LinuxDroidMaster.

use the script "git clone https://github.com/Mohameda332/auto-debian-install.git"
after that use "cd auto-debian-install && nano install.sh && chmod+x install.sh && ./install.sh"
with nano,change the places were it write username with another username like speedlight
sometimes you will need to add script and change words.
on /etc/sudoers/,add this line "username ALL=(ALL:ALL) ALL" after "root ALL=(ALL:ALL)
