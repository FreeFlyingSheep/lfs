#!/bin/bash
set -e

# 退格和删除键的行为在 Kbd 软件包的不同按键映射中不一致
# 以下补丁修复 i386 按键映射中的这个问题
patch -Np1 -i ../kbd-2.3.0-backspace-1.patch

# 删除多余的 resizecons 程序及其 man 页面
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

# 配置 Kbd
./configure --prefix=/usr --disable-vlock

# 编译 Kbd
make

# 测试 Kbd
# make check

# 安装 Kbd
make install

# 删除一个被无意安装的内部库
rm -v /usr/lib/libtswrap.{a,la,so*}
