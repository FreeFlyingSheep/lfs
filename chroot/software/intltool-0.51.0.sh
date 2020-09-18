#!/bin/bash
set -e

# 修复由 perl-5.22 及更新版本导致的警告
sed -i 's:\\\${:\\\$\\{:' intltool-update.in

# 准备编译 Intltool
./configure --prefix=/usr

# 编译 Intltool
make

# 测试 Intltool
# make check

# 安装 Intltool
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
