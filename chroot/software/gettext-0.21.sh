#!/bin/bash
set -e

# 准备编译 Gettext
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.21

# 编译 Gettext
make

# 测试 Gettext
# make check

# 安装 Gettext
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
