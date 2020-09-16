#!/bin/bash
set -e

tar -xf make-4.3.tar.gz
pushd make-4.3

# 准备编译 Make
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

# 编译 Make
make

# 安装 Make
make DESTDIR=$LFS install

popd
rm -rf make-4.3
