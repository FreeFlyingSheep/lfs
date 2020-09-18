#!/bin/bash
set -e

# 配置 Diffutils
./configure --prefix=/usr

# 编译 Diffutils
make

# 测试 Diffutils
# make check

# 安装 Diffutils
make install
