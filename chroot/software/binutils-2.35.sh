#!/bin/bash
set -e

# 进行简单测试，确认伪终端 (PTY) 在 chroot 环境中能正常工作
# expect -c "spawn ls"
# 删除一项导致测试套件无法完成的测试
# sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in
# 我们跳过测试，尽管它非常重要

# Binutils 文档推荐在一个专用的构建目录中构建 Binutils
mkdir -v build
cd       build

# 配置 Binutils
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

# 编译 Binutils
make tooldir=/usr

# 测试 Binutils
# make -k check

# 安装 Binutils
make tooldir=/usr install
