#!/bin/bash
set -e

# 编译 Zstd
make

# 安装 Zstd
make prefix=/usr install

# 删除静态库，并将共享库移动到 /lib。另外，.so 符号链接也要在 /usr/lib 中重建
rm -v /usr/lib/libzstd.a
mv -v /usr/lib/libzstd.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libzstd.so) /usr/lib/libzstd.so
