#!/bin/bash
set -e

# 配置 Bison
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.7.1

# 编译 Bison
make

# 测试 Bison
# make check

# 安装 Bison
make install
