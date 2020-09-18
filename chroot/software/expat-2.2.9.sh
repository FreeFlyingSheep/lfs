#!/bin/bash
set -e

# 配置 Expat
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.9

# 编译 Expat
make

# 测试 Expat
# make check

# 安装 Expat
make install

# 安装 Expat 的文档
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.9
