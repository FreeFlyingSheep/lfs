#!/bin/bash
set -e

# 准备编译 Inetutils
./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

# 编译 Inetutils
make

# 测试 Inetutils
# make check

# 安装 Inetutils
make install

# 移动一些程序，这样在 /usr 文件系统不可用时也能使用它们
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
