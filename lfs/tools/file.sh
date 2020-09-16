#!/bin/bash
set -e

tar -xf file-5.39.tar.gz
pushd file-5.39

# 准备编译 File
./configure --prefix=/usr --host=$LFS_TGT

# 编译 File
make

# 安装 File
make DESTDIR=$LFS install

popd
rm -rf file-5.39
