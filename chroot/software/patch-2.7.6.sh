#!/bin/bash
set -e

# 配置 Patch
./configure --prefix=/usr

# 编译 Patch
make

# 测试 Patch
# make check

# 安装 Patch
make install
