#!/bin/bash
set -e

# 准备编译 Findutils
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 Findutils
make

# 安装 Findutils
make DESTDIR=$LFS install
