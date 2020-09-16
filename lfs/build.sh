#!/bin/bash
set -e

cd ~/script

# 进行并行构建
export MAKEFLAGS='-j4'

if [ "$LFS" != "/mnt/lfs" ]; then
  echo "LFS 环境变量配置错误"
  exit 1
fi

# 编译交叉工具链
bash toolchain.sh

# 交叉编译临时工具
bash tools.sh

# 进入 Chroot 并构建其他临时工具
bash chroot.sh
