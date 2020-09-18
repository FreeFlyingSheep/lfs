#!/bin/bash
set -e

# 配置 Procps-ng
./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.16 \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd

# 编译 Procps-ng
make

# 测试 Procps-ng
# make check

# 安装 Procps-ng
make install

# 将必要的库移动到 /usr 尚未挂载时也能访问的位置
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
