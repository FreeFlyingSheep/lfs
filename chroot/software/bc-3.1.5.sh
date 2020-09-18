#!/bin/bash
set -e

# 配置 Bc
PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3

# 编译 Bc
make

# 测试 Bc
# make test

# 安装 Bc
make install
