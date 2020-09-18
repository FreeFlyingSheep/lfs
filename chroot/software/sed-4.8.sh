#!/bin/bash
set -e

# 准备编译 Sed
./configure --prefix=/usr --bindir=/bin

# 编译 Sed，并生成 HTML 文档
make
make html

# 测试 Sed
# chown -Rv tester .
# su tester -c "PATH=$PATH make check"

# 安装 Sed 及其文档
make install
install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8
