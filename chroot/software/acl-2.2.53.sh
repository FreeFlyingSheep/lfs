#!/bin/bash
set -e

# 准备编译 Acl
./configure --prefix=/usr         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53

# 编译 Acl
make

# Acl 的测试套件必须在构建了链接到 Acl 库的 Coreutils 后才能在支持访问控制的文件系统上运行
# 如果想运行它们，可以稍后返回这里，执行 make check，前提是本章中的 Coreutils 已经构建完成
# make check

# 安装 Acl
make install

# 共享库需要被移动到 /lib 目录，因此 /usr/lib 中的 .so 符号链接需要重新建立
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
