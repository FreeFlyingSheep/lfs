#!/bin/bash
set -e

# 准备编译 Flex
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4

# 编译 Flex
make

# 测试 Flex
# make check

# 安装 Flex
make install

# 个别程序还不知道 flex，并试图去运行它的前身 lex
# 为了支持这些程序，创建一个名为 lex 的符号链接，它运行 flex 并启动其模拟 lex 的模式
ln -sv flex /usr/bin/lex
