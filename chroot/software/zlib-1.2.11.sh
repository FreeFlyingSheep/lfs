#!/bin/bash
set -e

# 准备编译 Zlib
./configure --prefix=/usr

# 编译 Zlib
make

# 测试 Zlib
# make check

# 安装 Zlib
make install

# 共享库需要被移动到 /lib 中，因此 .so 文件需要在/usr/lib 目录中重建
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
