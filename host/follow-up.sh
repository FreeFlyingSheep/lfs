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

# 恢复 /etc/bash.bashrc
[ ! -e /etc/bash.bashrc.NOUSE ] || mv -v /etc/bash.bashrc.NOUSE /etc/bash.bashrc

# 删除 lfs 用户
userdel -r lfs
# 删除 lfs 用户组
groupdel lfs
