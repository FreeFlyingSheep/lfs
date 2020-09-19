#!/bin/bash
set -e

# 防止一个静态库的安装
sed -i '/install -m.*STACAPLIBNAME/d' libcap/Makefile

# 编译 Libcap
make lib=lib

# 测试 Libcap
# make test

# 安装 Libcap，并进行清理工作
make lib=lib PKGCONFIGDIR=/usr/lib/pkgconfig install
chmod -v 755 /lib/libcap.so.2.42
mv -v /lib/libpsx.a /usr/lib
rm -v /lib/libcap.so
ln -sfv ../../lib/libcap.so.2 /usr/lib/libcap.so
