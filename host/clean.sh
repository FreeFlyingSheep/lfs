#!/bin/bash
set -e

echo "清理上次的构建……"

if [ -f $DISK_LOG ]; then
  DISK=`cat $DISK_LOG`
  # 若 $LFS 被挂载，卸载它
  mount | grep -q "$LFS" && umount $LFS
fi

# 删除相关文件和目录
rm -rf $LFS
rm -f $DISK_LOG

# 若 lfs 用户存在，删除它
grep -q "lfs" /etc/passwd && userdel -r lfs
# 若 lfs 用户组存在，删除它
grep -q "lfs" /etc/group && groupdel lfs

rm -f $DISK_IMG
