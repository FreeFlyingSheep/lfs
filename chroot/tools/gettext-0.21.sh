#!/bin/bash
set -e

# 配置 Gettext
./configure --disable-shared

# 编译 Gettext
make

# 安装 msgfmt，msgmerge，以及 xgettext 这三个程序
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
