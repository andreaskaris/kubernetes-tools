#!/bin/bash

mkdir /loopbacks
mkdir /mnt/local-storage/loopbacks -p
for letter in a b c d ; do
        dd if=/dev/zero of=/loopbacks/disk$letter bs=100M count=1
        losetup -fP /loopbacks/disk$letter
done
losetup -a
for letter in a b c d ; do
        mkfs.ext4 -F /loopbacks/disk$letter
        mkdir /mnt/local-storage/loopbacks/$letter
        loopback=$(losetup | grep disk$letter | awk '{print $1}')
        mount -o loop $loopback /mnt/local-storage/loopbacks/$letter
done
chcon -R unconfined_u:object_r:svirt_sandbox_file_t:s0 /mnt/local-storage/
