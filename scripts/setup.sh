#!/bin/bash

set -e
apt update && apt upgrade -y
apt install -y gcc make linux-kernel-headers

mount /home/vagrant/VBoxGuestAdditions.iso /mnt
cd /mnt
/mnt/VBoxLinuxAdditions.run --nox11
cd /root
umount /mnt/

mkdir /home/vagrant/.ssh/
touch /home/vagrant/.ssh/authorized_keys
chown vagrant.vagrant /home/vagrant/.ssh
chown vagrant.vagrant /home/vagrant/.ssh/authorized_keys
# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
