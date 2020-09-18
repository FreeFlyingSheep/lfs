#!/bin/bash
set -e

# 修复 Perl 5.28 引入的 bug
sed -i '361 s/{/\\{/' bin/autoscan.in

# 配置 Autoconf
./configure --prefix=/usr

# 编译 Autoconf
make

# 目前由于 bash-5 和 libtool-2.4.3 的变化，测试套件无法正常工作
# 测试 Autoconf
# make check

# 安装 Autoconf
make install
