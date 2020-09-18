#!/bin/bash
set -e

# 确保不安装某些不需要的文件
sed -i 's/extras//' Makefile.in

# 配置 Gawk
./configure --prefix=/usr

# 编译 Gawk
make

# 测试 Gawk
# make check

# 安装 Gawk
make install

# 安装文档
mkdir -v /usr/share/doc/gawk-5.1.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.0
