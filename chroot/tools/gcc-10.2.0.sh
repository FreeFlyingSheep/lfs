#!/bin/bash
set -e

# 创建一个符号链接，允许在 GCC 源码树中构建 Libstdc++
ln -s gthr-posix.h libgcc/gthr-default.h

# GCC 文档建议在一个专用目录中构建 GCC
mkdir -v build
cd build

# 准备编译 Libstdc++
../libstdc++-v3/configure            \
    CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
    --prefix=/usr                    \
    --disable-multilib               \
    --disable-nls                    \
    --host=$(uname -m)-lfs-linux-gnu \
    --disable-libstdcxx-pch

# 编译 Libstdc++
make

# 安装 Libstdc++
make install
