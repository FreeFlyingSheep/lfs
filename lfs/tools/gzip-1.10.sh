#!/bin/bash
set -e

# 配置 Gzip
./configure --prefix=/usr --host=$LFS_TGT

# 编译 Gzip
make

# 安装 Gzip
make DESTDIR=$LFS install

# 将可执行文件移动到最终安装时的正确位置
mv -v $LFS/usr/bin/gzip $LFS/bin
