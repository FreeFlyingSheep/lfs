#!/bin/bash
set -e

tar -xf diffutils-3.7.tar.xz
pushd diffutils-3.7

准备编译 Diffutils
./configure --prefix=/usr --host=$LFS_TGT

# 编译 Diffutils
make

# 安装 Diffutils
make DESTDIR=$LFS install

popd
rm -rf diffutils-3.7
