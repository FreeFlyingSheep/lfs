#!/bin/bash
set -e

echo "创建虚拟磁盘……"
# 创建 20G 的虚拟磁盘 $DISK_IMG
dd if=/dev/zero of=$DISK_IMG bs=1M count=0 seek=10240
# 把虚拟磁盘采用 mbr 形式分区
parted -s $DISK_IMG mklabel msdos
# 把虚拟磁盘虚拟为块设备
losetup --show -f $DISK_IMG > $DISK_LOG
# 获取挂载的块设备
DISK=`cat $DISK_LOG`
echo "虚拟块设备位于 $DISK"
# 为虚拟磁盘分配一个根分区
parted -s $DISK mkpart primary 0 100%
# 格式化分区为 ext4 文件系统
mkfs.ext4 -v ${DISK}p1

echo "挂载虚拟磁盘……"
# 创建 /mnt/lfs
mkdir -pv $LFS
# 挂载虚拟磁盘
mount -v ${DISK}p1 $LFS
