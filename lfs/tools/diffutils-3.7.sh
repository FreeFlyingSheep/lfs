#!/bin/bash
set -e

# 准备编译 Diffutils
./configure --prefix=/usr --host=$LFS_TGT

# 编译 Diffutils
make

# 安装 Diffutils
make DESTDIR=$LFS install
