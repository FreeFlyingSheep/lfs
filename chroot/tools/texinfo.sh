#!/bin/bash
set -e

tar -xf texinfo-6.7.tar.xz
pushd texinfo-6.7

# 准备编译 Texinfo
./configure --prefix=/usr

# 编译 Texinfo
make

# 安装 Texinfo
make install

popd
rm -rf texinfo-6.7
