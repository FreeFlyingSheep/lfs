#!/bin/bash
set -e

# 准备编译 Python
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

# 编译 Python
make

# 安装 Python
make install
