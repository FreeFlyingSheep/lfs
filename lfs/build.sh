#!/bin/bash
set -e

# 进行并行构建
export MAKEFLAGS='-j8'

# 确认环境变量是否正确配置
if [ "$LFS" != "/mnt/lfs" ]; then
  echo "LFS 环境变量配置错误"
  exit 1
fi

# 编译交叉工具链
bash ~/scripts/toolchain.sh

# 交叉编译临时工具
bash ~/scripts/tools.sh
