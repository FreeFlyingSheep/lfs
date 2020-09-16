#!/bin/bash
set -e

echo "卸载虚拟磁盘……"
# 卸载虚拟磁盘
umount -v $LFS

# 卸除虚拟的块设备
DISK=`cat $DISK_LOG`
losetup -d $DISK

rmdir $LFS
rm $DISK_LOG
