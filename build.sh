#!/bin/bash
set -e

## 0. 说明
# 本脚本遵循 MIT 协议
# 本脚本用于自动构建 LFS systemd 10.0
# 目前本脚本还未完成！
VERSION=0.1

echo "    __    ___________"
echo "   / /   / ____/ ___/"
echo "  / /   / /_   \__ \ "
echo " / /___/ __/  ___/ / "
echo "/_____/_/    /____/  "

echo -e "\n自动构建 LFS systemd 10.0，脚本版本 v$VERSION\n"

## 1. 引言
if [ `id -u` -ne 0 ]; then
  echo "必须用 root 用户执行该脚本！"
  exit 1
fi

# 切换到脚本所在的目录
cd `dirname $0`

# 导出脚本所需的环境变量
export DISK_LOG=disk.log

bash host/clean.sh

## 2. 准备宿主系统
# 导出 $LFS 环境变量
export LFS=/mnt/lfs
echo "LFS=$LFS"

bash host/host.sh

export DISK=`cat ${DISK_LOG}`

## 3. 软件包和补丁
bash host/download.sh

## 4. 最后准备工作
bash host/prepare.sh

## 5. 编译交叉工具链
bash test.sh

## 6. 交叉编译临时工具
bash test.sh

## 7. 进入 Chroot 并构建其他临时工具
bash test.sh

## 8. 安装基本系统软件
bash test.sh

## 9. 系统配置
bash test.sh

## 10. 使 LFS 系统可引导
bash test.sh

## 11. 尾声
bash host/follow-up.sh

echo "构建完成！"
exit 0
