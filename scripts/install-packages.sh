#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

function wait_for_apt_lock() {
    while [ "" = "" ]; do
        eval "$1" 2>/dev/null
        if [ $? -eq 0 ]; then
            break
        fi
        sleep 1
        echo "Waiting for apt lock..."
    done
}

wait_for_apt_lock "touch /boot/grub/menu.lst"
wait_for_apt_lock "update-grub2"
wait_for_apt_lock "apt-get update -y"
wait_for_apt_lock "apt-get upgrade -y"
wait_for_apt_lock "apt autoremove --purge -y"

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

apt-get install -y awscli ec2-instance-connect gnupg

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get update
apt-get install -y mongodb-org
systemctl enable mongod