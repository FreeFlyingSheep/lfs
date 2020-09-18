#!/bin/bash
set -e

# 创建一个 LSB 兼容性符号链接
# 对于 x86_64，创建一个动态链接器正常工作所必须的符号链接
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

# 一些 Glibc 程序使用与 FHS 不兼容的 /var/db 目录存放它们的运行时数据
# 下面应用一个补丁，使得这些程序在 FHS 兼容的位置存放运行时数据
patch -Np1 -i ../glibc-2.32-fhs-1.patch

# Glibc 文档推荐在一个专用目录中构建 Glibc
mkdir -v build
cd build

# 准备编译 Glibc
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/lib

# 编译 Glibc
make

# 安装 Glibc
make DESTDIR=$LFS install
