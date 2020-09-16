#!/bin/bash
set -e

tar -xf grep-3.4.tar.xz
pushd grep-3.4

# 准备编译 Grep
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --bindir=/bin

# 编译 Grep
make

# 安装 Grep
make DESTDIR=$LFS install

popd
rm -rf grep-3.4
