#!/bin/bash
set -e

# 准备编译 MPFR
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.1.0

# 编译 MPFR，并生成 HTML 文档
make
make html

# 测试 MPFR
# make check

# 安装 MPFR
make install
make install-html
