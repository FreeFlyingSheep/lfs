#!/bin/bash
set -e

# 确保不要安装一些没有必要的文件
sed -i 's/extras//' Makefile.in

# 准备编译 Gawk
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./config.guess)

# 编译 Gawk
make

# 安装 Gawk
make DESTDIR=$LFS install
