#!/bin/bash
set -e

tar -xf xz-5.2.5.tar.xz
pushd xz-5.2.5

# 准备编译 Xz
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5

# 编译 Xz
make

# 安装 Xz
make DESTDIR=$LFS install

popd
rm -rf xz-5.2.5
