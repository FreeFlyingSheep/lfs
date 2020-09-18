#!/bin/bash
set -e

# 准备编译 Patch
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 Patch
make

# 安装 Patch
make DESTDIR=$LFS install
