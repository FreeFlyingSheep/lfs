#!/bin/bash
set -e

# 准备编译 Grep
./configure --prefix=/usr --bindir=/bin

# 编译 Grep
make

# 测试 Grep
# make check

# 安装 Grep
make install
