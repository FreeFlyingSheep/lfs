#!/bin/bash
set -e

echo "清理上次的构建……"

if [ -f $DISK_LOG ]; then
  bash host/umount.sh
fi

# 若 lfs 用户存在，删除它
grep -q "lfs" /etc/passwd && userdel -r lfs
# 若 lfs 用户组存在，删除它
grep -q "lfs" /etc/group && groupdel lfs

rm -f $DISK
