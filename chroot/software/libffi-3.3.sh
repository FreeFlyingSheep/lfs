#!/bin/bash
set -e

# 准备编译 Libffi
./configure --prefix=/usr --disable-static --with-gcc-arch=native

# 编译 Libffi
make

# 测试 Libffi
# make check

# 安装 Libffi
make install
