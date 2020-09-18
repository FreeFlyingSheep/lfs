#!/bin/bash
set -e

# 配置 Make
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 Make
make

# 安装 Make
make DESTDIR=$LFS install
