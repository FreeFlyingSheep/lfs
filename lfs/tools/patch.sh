#!/bin/bash
set -e

tar -xf patch-2.7.6.tar.xz
pushd patch-2.7.6

# 准备编译 Patch
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 Patch
make

# 安装 Patch
make DESTDIR=$LFS install

popd
rm -rf patch-2.7.6
