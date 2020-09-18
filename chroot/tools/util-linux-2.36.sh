#!/bin/bash
set -e

# 创建一个目录，允许 hwclock 程序存储数据
mkdir -pv /var/lib/hwclock

# 准备编译 Util-linux
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --docdir=/usr/share/doc/util-linux-2.36 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python

# 编译 Util-linux
make

# 安装 Util-linux
make install
