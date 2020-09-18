#!/bin/bash
set -e

# 修复一个 GCC-10 首先发现的问题
sed -r -i '/^char.*parseopt_program_(doc|args)/d' src/parseopt.c

# 配置 GDBM
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

# 编译 GDBM
make

# 测试 GDBM
# make check

# 安装 GDBM
make install
