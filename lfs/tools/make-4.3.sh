#!/bin/bash
set -e

# 准备编译 Make
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 Make
make

# 安装 Make
make DESTDIR=$LFS install
