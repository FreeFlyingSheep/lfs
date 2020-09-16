#!/bin/bash
set -e

tar -xf Python-3.8.5.tar.xz
pushd Python-3.8.5

# 准备编译 Python
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

# 编译 Python
make

# 安装 Python
make install

popd
rm -rf Python-3.8.5
