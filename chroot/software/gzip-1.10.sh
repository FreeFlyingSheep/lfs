#!/bin/bash
set -e

# 准备编译 Gzip
./configure --prefix=/usr

# 编译 Gzip
make

# 测试 Gzip
# make check

# 安装 Gzip
make install

# 移动一个必须放置在根文件系统的程序
mv -v /usr/bin/gzip /bin
