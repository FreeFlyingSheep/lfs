#!/bin/bash
set -e

# 准备编译 Bash
./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc

# 编译 Bash
make

# 安装 Bash
make DESTDIR=$LFS install

# 将可执行文件移动到正确位置
mv $LFS/usr/bin/bash $LFS/bin/bash

# 为那些使用 sh 命令运行 shell 的程序考虑，创建一个链接
ln -sv bash $LFS/bin/sh
