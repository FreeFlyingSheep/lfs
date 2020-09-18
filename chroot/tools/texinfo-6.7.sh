#!/bin/bash
set -e

# 配置 Texinfo
./configure --prefix=/usr

# 编译 Texinfo
make

# 安装 Texinfo
make install
