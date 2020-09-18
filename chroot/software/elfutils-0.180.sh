#!/bin/bash
set -e

# 准备编译 Libelf
./configure --prefix=/usr --disable-debuginfod --libdir=/lib

# 编译 Libelf
make

# 测试 Libelf
# make check

# 只安装 Libelf
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /lib/libelf.a
