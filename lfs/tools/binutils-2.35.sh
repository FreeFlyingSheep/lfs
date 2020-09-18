#!/bin/bash
set -e

# Binutils 文档推荐在一个专用的目录中构建 Binutils
mkdir -v build
cd       build

# 配置 Binutils
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd

# 编译 Binutils
make

# 安装 Binutils
make DESTDIR=$LFS install
