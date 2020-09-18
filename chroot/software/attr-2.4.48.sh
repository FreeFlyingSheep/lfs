#!/bin/bash
set -e

# 配置 Attr
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48

# 编译 Attr
make

# 测试 Attr
# make check

# 安装 Attr
make install

# 需要将共享库移动到 /lib 目录，因此 /usr/lib 中的 .so 符号链接也需要重新建立
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
