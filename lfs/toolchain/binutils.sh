#!/bin/bash
set -e

tar -xf binutils-2.35.tar.xz
pushd binutils-2.35

# Binutils 文档推荐在一个专用的目录中构建 Binutils
mkdir -v build
cd build

# 准备编译 Binutils
../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror

# 编译 Binutils
make

# 安装 Binutils
make install

popd
rm -rf binutils-2.35
