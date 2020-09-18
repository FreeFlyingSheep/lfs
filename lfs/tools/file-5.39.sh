#!/bin/bash
set -e

# 准备编译 File
./configure --prefix=/usr --host=$LFS_TGT

# 编译 File
make

# 安装 File
make DESTDIR=$LFS install
