#!/bin/bash
set -e

tar -xf bison-3.7.1.tar.xz
pushd bison-3.7.1

# 准备编译 Bison
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.7.1

# 编译 Bison
make

# 安装 Bison
make install

popd
rm -rf bison-3.7.1
