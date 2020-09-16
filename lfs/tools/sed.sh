#!/bin/bash
set -e

tar -xf sed-4.8.tar.xz
pushd sed-4.8

# 准备编译 Sed
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --bindir=/bin

# 编译 Sed
make

# 安装 Sed
make DESTDIR=$LFS install

popd
rm -rf sed-4.8
