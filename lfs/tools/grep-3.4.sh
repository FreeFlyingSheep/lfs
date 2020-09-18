#!/bin/bash
set -e

# 配置 Grep
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --bindir=/bin

# 编译 Grep
make

# 安装 Grep
make DESTDIR=$LFS install
