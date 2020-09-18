#!/bin/bash
set -e

# 配置 Tar
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --bindir=/bin

# 编译 Tar
make

# 安装 Tar
make DESTDIR=$LFS install
