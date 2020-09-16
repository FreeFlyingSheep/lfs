#!/bin/bash
set -e

tar -xf findutils-4.7.0.tar.xz
pushd findutils-4.7.0

# 准备编译 Findutils
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 Findutils
make

# 安装 Findutils
make DESTDIR=$LFS install

popd
rm -rf findutils-4.7.0
