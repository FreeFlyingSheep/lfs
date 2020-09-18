#!/bin/bash
set -e

# 若 $LFS 被挂载，卸载它
mount | grep -q "${LFS}/dev/pts" && umount -v ${LFS}/dev/pts
mount | grep -q "${LFS}/dev" && umount -v ${LFS}/dev
mount | grep -q "${LFS}/run" && umount -v ${LFS}/run
mount | grep -q "${LFS}/proc" && umount -v ${LFS}/proc
mount | grep -q "${LFS}/sys" && umount -v ${LFS}/sys
mount | grep -q "${LFS}" && umount -v ${LFS}

# 断开回环设备
losetup -D

# 删除相关文件和目录
rm -rfv ${LFS}

# 若 lfs 用户存在，删除它
grep -q "lfs" /etc/passwd && userdel -r lfs
# 若 lfs 用户组存在，删除它
grep -q "lfs" /etc/group && groupdel lfs

rm -fv ${DISK_IMG}
