#!/bin/bash
set -e

tar -xf tar-1.32.tar.xz
pushd tar-1.32

# 准备编译 Tar
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --bindir=/bin

# 编译 Tar
make

# 安装 Tar
make DESTDIR=$LFS install

popd
rm -rf tar-1.32
