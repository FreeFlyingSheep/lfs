#!/bin/bash
set -e

tar -xf gzip-1.10.tar.xz
pushd gzip-1.10

# 准备编译 Gzip
./configure --prefix=/usr --host=$LFS_TGT

# 编译 Gzip
make

# 安装 Gzip
make DESTDIR=$LFS install

# 将可执行文件移动到最终安装时的正确位置
mv -v $LFS/usr/bin/gzip $LFS/bin

popd
rm -rf gzip-1.10
