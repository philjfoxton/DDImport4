#!/bin/bash

set -e

echo "Removing elasticsearch state"
rm -rf /tmp/*

sed -i "/packer.*/d" /home/ubuntu/.ssh/authorized_keys
