#!/bin/bash
set -e

# 配置 Python
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

# 编译 Python
make

# 安装 Python
make install
