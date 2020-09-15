#!/bin/bash
set -e

bash host/umount.sh

# 恢复 /etc/bash.bashrc
[ ! -e /etc/bash.bashrc.NOUSE ] || mv -v /etc/bash.bashrc.NOUSE /etc/bash.bashrc

# 删除 lfs 用户
userdel -r lfs
# 删除 lfs 用户组
groupdel lfs
