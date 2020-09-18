#!/bin/bash
set -e

# 配置 Diffutils
./configure --prefix=/usr --host=$LFS_TGT

# 编译 Diffutils
make

# 安装 Diffutils
make DESTDIR=$LFS install
