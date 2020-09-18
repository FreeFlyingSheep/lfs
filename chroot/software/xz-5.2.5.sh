#!/bin/bash
set -e

# 编译 Xz
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5

# 编译 Xz
make

# 测试 Xz
# make check

# 安装 Xz，并保证所有重要文件都位于正确的目录中
make install
mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
