#!/bin/bash
set -e

# 配置 Libtool
./configure --prefix=/usr

# 编译 Libtool
make

# 测试 Libtool
# make check

# 安装 Libtool
make install
