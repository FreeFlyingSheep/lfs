#!/bin/bash
set -e

# 准备编译 Bc
PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3

# 编译 Bc
make

# 测试 Bc
# make test

# 安装 Bc
make install
