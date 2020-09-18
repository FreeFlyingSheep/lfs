#!/bin/bash
set -e

# GCC 文档推荐在一个专用的目录中构建 GCC
mkdir -v build
cd build

# 准备编译 Libstdc++
../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/10.2.0

# 编译 Libstdc++
make

# 安装 Libstdc++
make DESTDIR=$LFS install
