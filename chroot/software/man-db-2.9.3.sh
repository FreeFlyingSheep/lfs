#!/bin/bash
set -e

# 配置 Man-DB
sed -i '/find/s@/usr@@' init/systemd/man-db.service.in

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.9.3 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap

# 编译 Man-DB
make

# 测试 Man-DB
# make check

# 安装 Man-DB
make install
