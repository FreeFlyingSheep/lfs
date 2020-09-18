#!/bin/bash
set -e

# 配置 File
./configure --prefix=/usr

# 编译 File
make

# 测试 File
# make check

# 安装 File
make install
