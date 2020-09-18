#!/bin/bash
set -e

# 配置 File
./configure --prefix=/usr --host=$LFS_TGT

# 编译 File
make

# 安装 File
make DESTDIR=$LFS install
