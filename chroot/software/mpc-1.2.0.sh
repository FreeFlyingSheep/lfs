#!/bin/bash
set -e

# 配置 MPC
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.2.0

# 编译 MPC，并生成 HTML 文档
make
make html

# 测试 MPC
# make check

# 安装 MPC
make install
make install-html
