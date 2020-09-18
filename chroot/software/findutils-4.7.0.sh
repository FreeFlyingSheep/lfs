#!/bin/bash
set -e

# 配置 Findutils
./configure --prefix=/usr --localstatedir=/var/lib/locate

# 编译 Findutils
make

# 测试 Findutils
# chown -Rv tester .
# su tester -c "PATH=$PATH make check"

# 安装 Findutils
make install

# BLFS 及 BLFS 之外的一些软件包预期 find 程序在 /bin 中，因此要保证它被放置在那里
mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
