#!/bin/bash
set -e

# 配置 Tar
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin

# 编译 Tar
make

# 测试 Tar
# make check

# 安装 Tar
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.32
