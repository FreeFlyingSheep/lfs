#!/bin/bash
set -e

## 0. 说明
# 本脚本遵循 MIT 协议
# 本脚本用于自动构建 LFS systemd 10.0
VERSION=0.5

echo "    __    ___________"
echo "   / /   / ____/ ___/"
echo "  / /   / /_   \__ \ "
echo " / /___/ __/  ___/ / "
echo "/_____/_/    /____/  "

echo -e "\n自动构建 LFS systemd 10.0，脚本版本 v${VERSION}\n"

## 1. 引言
if [ `id -u` -ne 0 ]; then
  echo "必须用 root 用户执行该脚本！"
  exit 1
fi

# 切换到脚本所在的目录
cd `dirname $0`

# 导出脚本所需的环境变量
export DISK_IMG=disk.img
export DISK_LOG=disk.log

# 导出 $LFS 环境变量
export LFS=/mnt/lfs
echo "LFS=$LFS"

bash host/clean.sh

## 2. 准备宿主系统
bash host/host.sh

export DISK=`cat $DISK_LOG`

## 3. 软件包和补丁
bash host/download.sh

## 4. 最后准备工作
## 5. 编译交叉工具链
## 6. 交叉编译临时工具
# 这几个步骤在自动构建流程中是一个整体，涉及切换用户，很难分割
# host/prepare.sh 完成第 4 步，切换到 lfs 用户并把后续的任务交给 lfs/init.sh
# lfs/init.sh 完成第 5 步的前半部分，把后续的任务交给 lfs/build.sh
# lfs/build.sh 完成第 5 步的后半部分和第 6 步
bash host/lfs.sh

## 7. 进入 Chroot 并构建其他临时工具
## 8. 安装基本系统软件
## 9. 系统配置
# 同理，这几个步骤在自动构建流程中是一个整体，涉及 Chroot，很难分割
# chroot/init.sh 完成第 7 步的前半部分，把后续的任务交给 chroot/build.sh
# chroot/build.sh 完成第 7 步的后半部分和第 8 步，把后续任务交给 chroot/config.sh
# chroot/config.sh 完成第 9 步
bash host/chroot.sh

## 10. 使 LFS 系统可引导
echo "10!!!"

## 11. 尾声
bash host/follow-up.sh

echo "构建完成！"
exit 0
