#!/bin/bash
set -e

# 创建 20G 的虚拟磁盘 $DISK_IMG
dd if=/dev/zero of=lfs.img bs=1M count=0 seek=10240

# 把虚拟磁盘采用 mbr 形式分区
parted -s lfs.img mklabel msdos

# 把虚拟磁盘虚拟为块设备
losetup -f lfs.img

# 获取块设备名称
DISK=`losetup -l | grep "lfs.img" | cut -d" " -f 1`

# 为虚拟磁盘分配一个根分区
# 前 1M 用于以后安装 GRUB
parted -s ${DISK} mkpart primary 1M 100%

# 格式化分区为 ext4 文件系统
mkfs.ext4 -v ${DISK}p1

# 创建 /mnt/lfs
mkdir -pv ${LFS}

# 挂载虚拟磁盘
mount -v ${DISK}p1 ${LFS}
