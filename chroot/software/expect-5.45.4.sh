#!/bin/bash
set -e

# 准备编译 Expect
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

# 编译 Expect
make

# 测试 Expect
# make test

# 安装 Expect
make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
