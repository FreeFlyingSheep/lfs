#!/bin/bash
set -e

# 准备编译 Kmod
./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib

# 编译 Kmod
make

# 安装 Kmod，并创建与 Module-Init-Tools (曾经用于处理 Linux 内核模块的软件包) 兼容的符号链接
make install

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod
