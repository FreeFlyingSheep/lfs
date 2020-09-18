#!/bin/bash
set -e

# FHS 建议使用 /var/lib/hwclock 目录，而非一般的 /etc 目录作为 adjtime 文件的位置
mkdir -pv /var/lib/hwclock

# 配置 Util-linux
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
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

# 以非 root 用户身份测试 Util-linux
# chown -Rv tester .
# su tester -c "make -k check"

# 安装 Util-linux
make install
