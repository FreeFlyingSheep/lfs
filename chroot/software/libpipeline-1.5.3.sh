#!/bin/bash
set -e

# 配置 Libpipeline
./configure --prefix=/usr

# 编译 Libpipeline
make

# 测试 Libpipeline
# make check

# 安装 Libpipeline
make install
