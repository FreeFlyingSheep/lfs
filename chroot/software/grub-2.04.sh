#!/bin/bash
set -e

# 准备编译 GRUB
./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

# 编译 GRUB
make

# 安装 GRUB
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
