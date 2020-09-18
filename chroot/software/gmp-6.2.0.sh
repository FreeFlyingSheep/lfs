#!/bin/bash
set -e

# 准备编译 GMP
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.0

# 编译 GMP，并生成 HTML 文档
make
make html

# 测试 GMP
# make check 2>&1 | tee gmp-check-log

# 安装 GMP 及其文档
make install
make install-html
