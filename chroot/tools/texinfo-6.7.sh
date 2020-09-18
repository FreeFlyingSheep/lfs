#!/bin/bash
set -e

# 准备编译 Texinfo
./configure --prefix=/usr

# 编译 Texinfo
make

# 安装 Texinfo
make install
