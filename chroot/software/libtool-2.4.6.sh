#!/bin/bash
set -e

# 准备编译 Libtool
./configure --prefix=/usr

# 编译 Libtool
make

# 测试 Libtool
# make check

# 安装 Libtool
make install
