#!/bin/bash
/sbin/service rsyslog stop

/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old

/bin/rm -rf /var/log/installer/

/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/alternatives.log
/bin/cat /dev/null > /var/log/auth.log
/bin/cat /dev/null > /var/log/bootstrap.log
/bin/cat /dev/null > /var/log/btmp
/bin/cat /dev/null > /var/log/dmesg
/bin/cat /dev/null > /var/log/dpkg.log
/bin/cat /dev/null > /var/log/faillog
/bin/cat /dev/null > /var/log/kern.log
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/syslog
/bin/cat /dev/null > /var/log/wtmp

/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*
/bin/rm -f /etc/ssh/*key*
/bin/rm -f ~root/.bash_history
/bin/rm -rf ~root/.ssh/

dpkg-reconfigure openssh-server
wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

sudo apt-get purge -y binutils cpp cpp-5 gcc gcc-5 libasan2 libatomic1
sudo apt-get purge -y libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libgcc-5-dev
sudo apt-get purge -y libgomp1 libisl15 libitm1 liblsan0 libmpc3 libmpfr4 libmpx0
sudo apt-get purge -y libquadmath0 libtsan0 libubsan0 linux-libc-dev make manpages
sudo apt-get purge -y manpages-dev wireless-regdb libxmuu1 libcap-ng0 libtext-wrapi18n-perl
sudo apt-get purge -y whiptail libgdbm3 libxtables11 os-prober libfribidi0 libusb-1.0-0 libatm1
sudo apt-get purge -y console-setup libpci3 tcpd libxext6 xdg-user-dirs
sudo apt-get purge -y libslang2 shared-mime-info krb5-locales xkb-data libglib2.0-0
sudo apt-get purge -y ssh-import-id ncurses-term
sudo apt-get purge -y language-pack-gnome-en language-pack-en libx11-6
sudo apt-get purge -y makedev emacsen-common eject dmeventd linux-firmware tasksel

# Clean up old kernels and headers
echo $(dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p') $(dpkg --list | grep linux-headers | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p') | xargs sudo apt-get -y purge
sudo apt purge linux-header* -y

sudo apt autoremove -y
sudo apt install -y dialog wget dbus vim jq git curl psmisc lsof rng-tools apt-transport-https
sudo apt autoclean
sudo apt clean

sudo rm -f /home/vagrant/*.iso
# Zero out the rest of the free space using dd, then delete the written file.
sudo dd if=/dev/zero of=/EMPTY bs=1M 
sudo rm -f /EMPTY
/usr/bin/update-alternatives --set editor /usr/bin/vim.basic


unset HISTFILE
# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sudo sync
exit 0
