#!/bin/bash
set -e

# 配置 Pkg-config
./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2

# 编译 Pkg-config
make

# 测试 Pkg-config
# make check

# 安装 Pkg-config
make install
