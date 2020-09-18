#!/bin/bash
set -e

# Binutils 文档推荐在一个专用的目录中构建 Binutils
mkdir -v build
cd       build

# 配置 Binutils
../configure --prefix=$LFS/tools        \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror

# 编译 Binutils
make

# 安装 Binutils
make install
