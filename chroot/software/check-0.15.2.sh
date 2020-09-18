#!/bin/bash
set -e

# 准备编译 Check
./configure --prefix=/usr --disable-static

# 编译 Check
make

# 测试 Check
# make check

# 安装 Check
make docdir=/usr/share/doc/check-0.15.2 install
