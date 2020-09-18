#!/bin/bash
set -e

# 原 .bashrc 文件的内容
# 具体见 lfs/init.sh 中的注释
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
export LFS LC_ALL LFS_TGT PATH

# 进行并行构建
export MAKEFLAGS='-j8'

# 确认环境变量是否正确配置
# 显然这一步在该脚本中是多余的
# echo "$LFS"

cd $LFS/sources

echo "编译交叉工具链……"
bash ~/scripts/toolchain.sh
echo -e "编译交叉工具链完成！\n"

echo "交叉编译临时工具……"
bash ~/scripts/tools.sh
echo -e "交叉编译临时工具完成！\n"
