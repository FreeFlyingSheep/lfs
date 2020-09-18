#!/bin/bash
set -e

# 配置 Sed
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --bindir=/bin

# 编译 Sed
make

# 安装 Sed
make DESTDIR=$LFS install
